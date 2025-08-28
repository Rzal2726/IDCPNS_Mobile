import 'package:get/get.dart';

import '../controllers/mutasi_saldo_controller.dart';

class MutasiSaldoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MutasiSaldoController>(
      () => MutasiSaldoController(),
    );
  }
}
