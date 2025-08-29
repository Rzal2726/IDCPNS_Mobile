import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pembahasan_tryout_harian_controller.dart';

class PembahasanTryoutHarianView
    extends GetView<PembahasanTryoutHarianController> {
  const PembahasanTryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PembahasanTryoutHarianView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PembahasanTryoutHarianView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
