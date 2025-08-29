import 'package:get/get.dart';

import '../controllers/pengerjaan_tryout_harian_controller.dart';

class PengerjaanTryoutHarianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengerjaanTryoutHarianController>(
      () => PengerjaanTryoutHarianController(),
    );
  }
}
