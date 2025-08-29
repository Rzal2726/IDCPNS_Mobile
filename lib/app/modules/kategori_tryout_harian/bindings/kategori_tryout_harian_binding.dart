import 'package:get/get.dart';

import '../controllers/kategori_tryout_harian_controller.dart';

class KategoriTryoutHarianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KategoriTryoutHarianController>(
      () => KategoriTryoutHarianController(),
    );
  }
}
