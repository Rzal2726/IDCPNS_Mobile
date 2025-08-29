import 'package:get/get.dart';

import '../controllers/panduan_tryout_harian_controller.dart';

class PanduanTryoutHarianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PanduanTryoutHarianController>(
      () => PanduanTryoutHarianController(),
    );
  }
}
