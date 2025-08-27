import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import '../controllers/detail_tryout_controller.dart';

class DetailTryoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailTryoutController>(() => DetailTryoutController());
    Get.lazyPut<RestClientProvider>(() => RestClientProvider());
  }
}
