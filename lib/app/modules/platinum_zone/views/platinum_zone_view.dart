import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/platinum_zone_controller.dart';

class PlatinumZoneView extends GetView<PlatinumZoneController> {
  const PlatinumZoneView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlatinumZoneView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PlatinumZoneView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
