import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_webinar_controller.dart';

class DetailWebinarView extends GetView<DetailWebinarController> {
  const DetailWebinarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailWebinarView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailWebinarView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
