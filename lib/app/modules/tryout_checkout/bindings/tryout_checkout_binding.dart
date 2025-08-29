import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

import '../controllers/tryout_checkout_controller.dart';

class TryoutCheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TryoutCheckoutController>(() => TryoutCheckoutController());

    Get.lazyPut<RestClientProvider>(() => RestClientProvider());
  }
}
