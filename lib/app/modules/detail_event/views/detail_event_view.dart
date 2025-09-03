import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_event_controller.dart';

class DetailEventView extends GetView<DetailEventController> {
  const DetailEventView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DetailEventView'), centerTitle: true),
      body: const Center(
        child: Text(
          'DetailEventView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
