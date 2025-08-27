import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

class TryoutCheckoutController extends GetxController {
  //TODO: Implement TryoutCheckoutController
  RxList<String> option = ["ATM", "MBanking"].obs;
  RxString selectedOption = "ATM".obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void fetchDetailPayment() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/transaction/payment-history/{uuid}',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void fetchServerTime() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/general/server-time',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void simulatePayment() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.post(
      '/transaction/simulate',
      {"payment_id": "string"},
      headers: {"Authorization": ""},
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }
}
