import 'package:get/get.dart';

import '../controllers/checkout_gagal_controller.dart';

class CheckoutGagalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutGagalController>(
      () => CheckoutGagalController(),
    );
  }
}
