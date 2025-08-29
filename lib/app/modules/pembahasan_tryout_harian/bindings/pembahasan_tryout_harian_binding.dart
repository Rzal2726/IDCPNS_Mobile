import 'package:get/get.dart';

import '../controllers/pembahasan_tryout_harian_controller.dart';

class PembahasanTryoutHarianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PembahasanTryoutHarianController>(
      () => PembahasanTryoutHarianController(),
    );
  }
}
