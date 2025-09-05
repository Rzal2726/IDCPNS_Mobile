import 'package:get/get.dart';

import '../controllers/payment_whislist_controller.dart';

class PaymentWhislistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentWhislistController>(
      () => PaymentWhislistController(),
    );
  }
}
