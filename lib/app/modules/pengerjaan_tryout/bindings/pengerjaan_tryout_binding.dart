import 'package:get/get.dart';

import '../controllers/pengerjaan_tryout_controller.dart';

class PengerjaanTryoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengerjaanTryoutController>(
      () => PengerjaanTryoutController(),
    );
  }
}
