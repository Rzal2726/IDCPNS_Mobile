import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_video_controller.dart';

class DetailVideoView extends GetView<DetailVideoController> {
  const DetailVideoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailVideoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailVideoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
