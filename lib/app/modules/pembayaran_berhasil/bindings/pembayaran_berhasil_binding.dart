import 'package:get/get.dart';

import '../controllers/pembayaran_berhasil_controller.dart';

class PembayaranBerhasilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PembayaranBerhasilController>(
      () => PembayaranBerhasilController(),
    );
  }
}
