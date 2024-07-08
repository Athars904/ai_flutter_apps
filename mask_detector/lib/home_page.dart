import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _cameraController;
  bool _isDetecting = false;
  List _output = [];  // Initialize _output with an empty list
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    loadModel();
    initializeCamera();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/mask_model.tflite',
      labels: 'assets/mask_labels.txt',
    );
  }

  void initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;
      _cameraController = CameraController(camera, ResolutionPreset.medium);
      await _cameraController.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
      _cameraController.startImageStream((CameraImage image) {
        if (!_isDetecting) {
          _isDetecting = true;
          detectImage(image);
        }
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void detectImage(CameraImage image) async {
    var output = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((plane) => plane.bytes).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 2,
      threshold: 0.6,
    );
    setState(() {
      _output = output!;
      _isDetecting = false;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          _isCameraInitialized
              ? AspectRatio(
            aspectRatio: _cameraController.value.aspectRatio,
            child: CameraPreview(_cameraController),
          )
              : const Center(
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 20),
          _output.isNotEmpty
              ? Text('${_output[0]['label']}')
              : const Text('Detecting...'),
          const SizedBox(height: 20),
          const Text(
            'Mask Detection',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
