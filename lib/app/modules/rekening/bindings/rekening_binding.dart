import 'package:get/get.dart';

import '../controllers/rekening_controller.dart';

class RekeningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RekeningController>(
      () => RekeningController(),
    );
  }
}
