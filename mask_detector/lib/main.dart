import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_detector/home_page.dart';
import 'package:camera/camera.dart';
List<CameraDescription>cameras=[];

Future<void> main() async{
  cameras=await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
     home: HomePage(),
    );
  }
}

