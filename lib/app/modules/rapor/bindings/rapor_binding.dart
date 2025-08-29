import 'package:get/get.dart';

import '../controllers/rapor_controller.dart';

class RaporBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RaporController>(
      () => RaporController(),
    );
  }
}
