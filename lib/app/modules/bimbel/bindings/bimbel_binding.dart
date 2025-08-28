import 'package:get/get.dart';

import '../controllers/bimbel_controller.dart';

class BimbelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BimbelController>(
      () => BimbelController(),
    );
  }
}
