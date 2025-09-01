import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // putih polos
      body: GetBuilder<SplashController>(
        init: SplashController(),
        builder: (controller) {
          return Center(
            child: Image.asset(
              'assets/icon/iconApp.png',
              width: 180,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
