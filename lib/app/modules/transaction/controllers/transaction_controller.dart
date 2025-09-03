import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class TransactionController extends GetxController {
  final _restClient = RestClient();
  RxMap transactions = {}.obs;
  RxString selectedFilter = "Semua".obs;
  final count = 0.obs;
  @override
  void onInit() {
    getTransaction();
    super.onInit();
    // Dummy data
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getTransaction() async {
    try {
      final url = await baseUrl + apiGetTransaction;

      final result = await _restClient.postData(url: url);

      if (result["status"] == "success") {
        var data = result['data'];
        transactions.value = data;
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
