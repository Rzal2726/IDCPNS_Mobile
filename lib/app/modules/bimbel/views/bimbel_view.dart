import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bimbel_controller.dart';

class BimbelView extends GetView<BimbelController> {
  const BimbelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BimbelView'), centerTitle: true),
      body: const Center(
        child: Text('BimbelView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
