import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/payment_upgrade_akun_controller.dart';

class PaymentUpgradeAkunView extends GetView<PaymentUpgradeAkunController> {
  const PaymentUpgradeAkunView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaymentUpgradeAkunView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PaymentUpgradeAkunView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
