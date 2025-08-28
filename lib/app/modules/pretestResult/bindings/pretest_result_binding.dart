import 'package:get/get.dart';

import '../controllers/pretest_result_controller.dart';

class PretestResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PretestResultController>(
      () => PretestResultController(),
    );
  }
}
