import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pengerjaan_tryout_harian_controller.dart';

class PengerjaanTryoutHarianView
    extends GetView<PengerjaanTryoutHarianController> {
  const PengerjaanTryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PengerjaanTryoutHarianView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PengerjaanTryoutHarianView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
