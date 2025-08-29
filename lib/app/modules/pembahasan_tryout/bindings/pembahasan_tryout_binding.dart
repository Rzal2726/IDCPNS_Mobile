import 'package:get/get.dart';

import '../controllers/pembahasan_tryout_controller.dart';

class PembahasanTryoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PembahasanTryoutController>(
      () => PembahasanTryoutController(),
    );
  }
}
