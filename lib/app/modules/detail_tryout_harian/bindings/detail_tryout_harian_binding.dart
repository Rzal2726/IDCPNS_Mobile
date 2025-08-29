import 'package:get/get.dart';

import '../controllers/detail_tryout_harian_controller.dart';

class DetailTryoutHarianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailTryoutHarianController>(
      () => DetailTryoutHarianController(),
    );
  }
}
