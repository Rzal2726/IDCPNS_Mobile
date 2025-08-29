import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/webinar_controller.dart';

class WebinarView extends GetView<WebinarController> {
  const WebinarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebinarView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WebinarView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
