import 'package:get/get.dart';

import '../controllers/detail_pengerjaan_tryout_controller.dart';

class DetailPengerjaanTryoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPengerjaanTryoutController>(
      () => DetailPengerjaanTryoutController(),
    );
  }
}
