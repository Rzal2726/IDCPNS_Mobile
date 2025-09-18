import 'package:get/get.dart';

import '../controllers/tryout_event_payment_controller.dart';

class TryoutEventPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TryoutEventPaymentController>(
      () => TryoutEventPaymentController(),
    );
  }
}
