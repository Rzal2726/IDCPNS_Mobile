import 'package:get/get.dart';

import '../controllers/upgrade_akun_controller.dart';

class UpgradeAkunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpgradeAkunController>(
      () => UpgradeAkunController(),
    );
  }
}
