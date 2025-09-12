import 'package:get/get.dart';

import '../controllers/lengkapi_biodata_controller.dart';

class LengkapiBiodataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LengkapiBiodataController>(
      () => LengkapiBiodataController(),
    );
  }
}
