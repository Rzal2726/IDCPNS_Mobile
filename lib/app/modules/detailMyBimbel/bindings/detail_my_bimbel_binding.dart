import 'package:get/get.dart';

import '../controllers/detail_my_bimbel_controller.dart';

class DetailMyBimbelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailMyBimbelController>(
      () => DetailMyBimbelController(),
    );
  }
}
