import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/video_series_controller.dart';

class VideoSeriesView extends GetView<VideoSeriesController> {
  const VideoSeriesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VideoSeriesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VideoSeriesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
