import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

import '../controllers/hasil_tryout_controller.dart';

class HasilTryoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HasilTryoutController>(() => HasilTryoutController());

    Get.lazyPut<RestClientProvider>(() => RestClientProvider());
  }
}
