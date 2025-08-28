import 'package:get/get.dart';

import '../controllers/tarik_komisi_controller.dart';

class TarikKomisiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TarikKomisiController>(
      () => TarikKomisiController(),
    );
  }
}
