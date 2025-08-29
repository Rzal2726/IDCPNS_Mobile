import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/checkout_upgrade_akun_controller.dart';

class CheckoutUpgradeAkunView extends GetView<CheckoutUpgradeAkunController> {
  const CheckoutUpgradeAkunView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckoutUpgradeAkunView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CheckoutUpgradeAkunView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
