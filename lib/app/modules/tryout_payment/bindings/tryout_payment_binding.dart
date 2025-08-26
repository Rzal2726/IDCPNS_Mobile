import 'package:get/get.dart';

import '../controllers/tryout_payment_controller.dart';

class TryoutPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TryoutPaymentController>(
      () => TryoutPaymentController(),
    );
  }
}
