import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/hasil_tryout_controller.dart';

class HasilTryoutView extends GetView<HasilTryoutController> {
  const HasilTryoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HasilTryoutView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HasilTryoutView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
