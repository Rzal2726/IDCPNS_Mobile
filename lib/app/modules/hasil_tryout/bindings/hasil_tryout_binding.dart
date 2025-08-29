import 'package:get/get.dart';

import '../controllers/hasil_tryout_controller.dart';

class HasilTryoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HasilTryoutController>(
      () => HasilTryoutController(),
    );
  }
}
