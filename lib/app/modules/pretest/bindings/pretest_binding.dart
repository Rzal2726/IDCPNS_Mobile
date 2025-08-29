import 'package:get/get.dart';

import '../controllers/pretest_controller.dart';

class PretestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PretestController>(
      () => PretestController(),
    );
  }
}
