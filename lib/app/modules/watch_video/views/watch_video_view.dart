import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/watch_video_controller.dart';

class WatchVideoView extends GetView<WatchVideoController> {
  const WatchVideoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WatchVideoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WatchVideoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
