import 'package:get/get.dart';

import '../controllers/tryout_harian_controller.dart';

class TryoutHarianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TryoutHarianController>(
      () => TryoutHarianController(),
    );
  }
}
