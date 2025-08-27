import 'package:get/get.dart';

import '../controllers/tryout_checkout_controller.dart';

class TryoutCheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TryoutCheckoutController>(
      () => TryoutCheckoutController(),
    );
  }
}
