import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/upgrade_akun_controller.dart';

class UpgradeAkunView extends GetView<UpgradeAkunController> {
  const UpgradeAkunView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpgradeAkunView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UpgradeAkunView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
