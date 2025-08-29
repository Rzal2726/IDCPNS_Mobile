import 'package:get/get.dart';
import '../controllers/bimbel_ricord_controller.dart';

class BimbelRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BimbelRecordController>(() => BimbelRecordController());
  }
}
