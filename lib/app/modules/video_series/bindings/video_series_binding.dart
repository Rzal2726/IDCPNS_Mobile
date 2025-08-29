import 'package:get/get.dart';

import '../controllers/video_series_controller.dart';

class VideoSeriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoSeriesController>(
      () => VideoSeriesController(),
    );
  }
}
