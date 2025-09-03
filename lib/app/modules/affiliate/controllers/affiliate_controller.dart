import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class AffiliateController extends GetxController {
  final _restClient = RestClient();
  RxString affiliateStatus = "".obs;
  RxMap finaceData = {}.obs;
  RxInt komisiTotal = 0.obs;
  RxInt komisiTersedia = 0.obs;
  RxInt komisiDitarik = 0.obs;

  TextEditingController kodeController = TextEditingController(
    text: "E14F7E74",
  );
  @override
  void onInit() {
    getCheckAffiliate();
    getFinance();
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

  void simpanKode() {
    // Tambahkan logika simpan kode
    Get.snackbar(
      "Sukses",
      "Kode berhasil disimpan",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> getCheckAffiliate() async {
    try {
      final url = await baseUrl + apiGetCheckAfiliasi;

      final result = await _restClient.getData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        affiliateStatus.value = result["exist"];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getFinance() async {
    try {
      final url = await baseUrl + apiGetFinance;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        finaceData.value = result['data'];
        komisiTotal.value = finaceData['komisi_total'];
        komisiTersedia.value = finaceData['komisi_tersedia'];
        komisiDitarik.value = finaceData['komisi_ditarik'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
