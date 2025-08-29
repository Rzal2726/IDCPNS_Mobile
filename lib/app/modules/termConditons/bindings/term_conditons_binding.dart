import 'package:get/get.dart';

import '../controllers/term_conditons_controller.dart';

class TermConditonsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermConditonsController>(
      () => TermConditonsController(),
    );
  }
}
