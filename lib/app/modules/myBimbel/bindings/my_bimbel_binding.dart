import 'package:get/get.dart';

import '../controllers/my_bimbel_controller.dart';

class MyBimbelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBimbelController>(
      () => MyBimbelController(),
    );
  }
}
