import 'package:get/get.dart';

import '../controllers/commision_detail_controller.dart';

class CommisionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommisionDetailController>(
      () => CommisionDetailController(),
    );
  }
}
