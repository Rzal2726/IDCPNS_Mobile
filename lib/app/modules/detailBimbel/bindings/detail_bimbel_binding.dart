import 'package:get/get.dart';

import '../controllers/detail_bimbel_controller.dart';

class DetailBimbelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBimbelController>(
      () => DetailBimbelController(),
    );
  }
}
