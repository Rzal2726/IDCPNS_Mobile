import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/peringkat_tryout_harian_controller.dart';

class PeringkatTryoutHarianView
    extends GetView<PeringkatTryoutHarianController> {
  const PeringkatTryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PeringkatTryoutHarianView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PeringkatTryoutHarianView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
