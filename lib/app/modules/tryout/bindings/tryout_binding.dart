import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

import '../controllers/tryout_controller.dart';

class TryoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TryoutController>(() => TryoutController());
  }
}
