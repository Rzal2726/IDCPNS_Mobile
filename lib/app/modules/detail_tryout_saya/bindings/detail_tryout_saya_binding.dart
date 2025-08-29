import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

import '../controllers/detail_tryout_saya_controller.dart';

class DetailTryoutSayaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailTryoutSayaController>(() => DetailTryoutSayaController());
    Get.lazyPut<RestClientProvider>(() => RestClientProvider());
  }
}
