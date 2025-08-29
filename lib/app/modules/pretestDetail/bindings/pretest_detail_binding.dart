import 'package:get/get.dart';

import '../controllers/pretest_detail_controller.dart';

class PretestDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PretestDetailController>(
      () => PretestDetailController(),
    );
  }
}
