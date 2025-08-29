import 'package:get/get.dart';

import '../controllers/payment_checkout_controller.dart';

class PaymentCheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentCheckoutController>(
      () => PaymentCheckoutController(),
    );
  }
}
