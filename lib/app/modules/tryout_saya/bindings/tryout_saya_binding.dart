import 'package:get/get.dart';

import '../controllers/tryout_saya_controller.dart';

class TryoutSayaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TryoutSayaController>(
      () => TryoutSayaController(),
    );
  }
}
