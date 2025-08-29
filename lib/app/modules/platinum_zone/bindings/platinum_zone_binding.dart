import 'package:get/get.dart';

import '../controllers/platinum_zone_controller.dart';

class PlatinumZoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlatinumZoneController>(
      () => PlatinumZoneController(),
    );
  }
}
