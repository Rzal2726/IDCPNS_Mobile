import 'package:get/get.dart';

import '../controllers/detail_tryout_saya_controller.dart';

class DetailTryoutSayaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailTryoutSayaController>(
      () => DetailTryoutSayaController(),
    );
  }
}
