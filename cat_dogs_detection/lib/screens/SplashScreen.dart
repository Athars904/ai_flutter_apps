import 'package:cat_dogs_detection/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});
  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
    Get.to(()=>HomePage());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
      child:Icon(CupertinoIcons.paw),
    );
  }
}
