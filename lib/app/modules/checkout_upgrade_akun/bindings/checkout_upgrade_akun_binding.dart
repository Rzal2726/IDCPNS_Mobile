import 'package:get/get.dart';

import '../controllers/checkout_upgrade_akun_controller.dart';

class CheckoutUpgradeAkunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutUpgradeAkunController>(
      () => CheckoutUpgradeAkunController(),
    );
  }
}
