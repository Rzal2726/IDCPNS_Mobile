import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/rapor_controller.dart';

class RaporView extends GetView<RaporController> {
  const RaporView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RaporView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RaporView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
