import 'package:get/get.dart';

import '../controllers/peringkat_tryout_harian_controller.dart';

class PeringkatTryoutHarianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeringkatTryoutHarianController>(
      () => PeringkatTryoutHarianController(),
    );
  }
}
