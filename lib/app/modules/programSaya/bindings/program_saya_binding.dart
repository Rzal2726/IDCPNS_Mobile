import 'package:get/get.dart';

import '../controllers/program_saya_controller.dart';

class ProgramSayaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgramSayaController>(
      () => ProgramSayaController(),
    );
  }
}
