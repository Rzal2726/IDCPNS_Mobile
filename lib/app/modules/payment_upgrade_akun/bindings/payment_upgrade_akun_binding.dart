import 'package:get/get.dart';

import '../controllers/payment_upgrade_akun_controller.dart';

class PaymentUpgradeAkunBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentUpgradeAkunController>(
      () => PaymentUpgradeAkunController(),
    );
  }
}
