import 'package:get/get.dart';

import '../controllers/peringkat_tryout_controller.dart';

class PeringkatTryoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeringkatTryoutController>(
      () => PeringkatTryoutController(),
    );
  }
}
