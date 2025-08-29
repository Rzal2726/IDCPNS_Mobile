import 'package:get/get.dart';

import '../controllers/pretest_tour_controller.dart';

class PretestTourBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PretestTourController>(
      () => PretestTourController(),
    );
  }
}
