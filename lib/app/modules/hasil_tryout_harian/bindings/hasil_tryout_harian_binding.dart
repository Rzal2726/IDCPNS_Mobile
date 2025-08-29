import 'package:get/get.dart';

import '../controllers/hasil_tryout_harian_controller.dart';

class HasilTryoutHarianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HasilTryoutHarianController>(
      () => HasilTryoutHarianController(),
    );
  }
}
