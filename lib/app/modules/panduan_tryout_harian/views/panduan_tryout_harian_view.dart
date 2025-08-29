import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/panduan_tryout_harian_controller.dart';

class PanduanTryoutHarianView extends GetView<PanduanTryoutHarianController> {
  const PanduanTryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PanduanTryoutHarianView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PanduanTryoutHarianView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
