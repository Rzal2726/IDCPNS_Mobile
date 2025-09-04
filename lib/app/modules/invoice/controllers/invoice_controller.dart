import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class InvoiceController extends GetxController {
  final _restClient = RestClient();
  RxMap notifData = {}.obs;
  RxString buyer = "Nawan Tutu".obs;
  RxString invoiceNumber = "INV/20250702/UPG/1/597039".obs;
  RxString transactionDate = "2025-07-02 14:55:10".obs;
  RxString status = "Sukses".obs;
  RxList items =
      [
        {"name": "Platinum 1 Bulan", "expired": "2025-08-02 14:55:43"},
        {"name": "Bonus Platinum SKD CPNS", "expired": "2025-08-02 14:55:43"},
      ].obs;
  RxInt adminFee = 4440.obs;
  RxInt discount = 0.obs;
  RxInt total = 133440.obs;

  final count = 0.obs;
  @override
  void onInit() {
    getData();
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

  Future<void> getData() async {
    try {
      final url = await baseUrl + apiGetTransaction;

      final result = await _restClient.postData(url: url);

      if (result["status"] == "success") {
        var id = Get.arguments;

        // pastikan result['data'] berupa list
        var data = result['data']['data'] as List;

        // cari data pertama yang id-nya sesuai dengan argument
        var found = data.firstWhere(
          (item) => item['id'] == id,
          orElse: () => null, // biar gak error kalau ga ketemu
        );

        if (found != null) {
          notifData.value = found;
        } else {
          print("Data dengan id $id tidak ditemukan");
        }
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
