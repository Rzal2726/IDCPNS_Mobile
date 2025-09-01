import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

import '../controllers/pengerjaan_tryout_controller.dart';

class PengerjaanTryoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengerjaanTryoutController>(() => PengerjaanTryoutController());
    Get.lazyPut<RestClientProvider>(() => RestClientProvider());
  }
}
