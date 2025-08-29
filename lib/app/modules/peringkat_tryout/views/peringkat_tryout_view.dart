import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/peringkat_tryout_controller.dart';

class PeringkatTryoutView extends GetView<PeringkatTryoutController> {
  const PeringkatTryoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PeringkatTryoutView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PeringkatTryoutView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
