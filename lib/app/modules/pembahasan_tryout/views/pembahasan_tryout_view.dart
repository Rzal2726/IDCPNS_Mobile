import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pembahasan_tryout_controller.dart';

class PembahasanTryoutView extends GetView<PembahasanTryoutController> {
  const PembahasanTryoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PembahasanTryoutView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PembahasanTryoutView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
