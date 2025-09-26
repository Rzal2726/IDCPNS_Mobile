import 'package:get/get.dart';

import '../controllers/tryout_event_free_payment_controller.dart';

class TryoutEventFreePaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TryoutEventFreePaymentController>(
      () => TryoutEventFreePaymentController(),
    );
  }
}
