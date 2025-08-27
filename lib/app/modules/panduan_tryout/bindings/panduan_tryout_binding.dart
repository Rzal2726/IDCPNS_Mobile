import 'package:get/get.dart';

import '../controllers/panduan_tryout_controller.dart';

class PanduanTryoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PanduanTryoutController>(
      () => PanduanTryoutController(),
    );
  }
}
