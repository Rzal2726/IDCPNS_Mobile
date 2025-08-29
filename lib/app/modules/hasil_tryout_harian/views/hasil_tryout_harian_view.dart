import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/hasil_tryout_harian_controller.dart';

class HasilTryoutHarianView extends GetView<HasilTryoutHarianController> {
  const HasilTryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HasilTryoutHarianView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HasilTryoutHarianView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
