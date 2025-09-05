import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class PaymentWhislistController extends GetxController {
  final _restClient = RestClient();
  RxList wishLishData = [].obs;
  RxList paymantListData = [].obs;
  var paketUtama = "Bimbel SKD CPNS 2024 Batch 12".obs;
  var paketUtamaTipe = "Reguler".obs;

  var paketLainnya = "Bimbel SKD CPNS 2025 Batch 16".obs;
  var selectedPaketLainnya = "".obs;

  var harga = 199000.obs;
  var totalHarga = 199000.obs;

  var metodePembayaran = "".obs;
  var kodePromo = "".obs;
  final productChecked = <int, bool>{}.obs;
  final count = 0.obs;
  @override
  void onInit() {
    getData();
    getPaymentData();
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

  void pilihPaketLainnya(String value) {
    selectedPaketLainnya.value = value;

    if (value.contains("Platinum")) {
      totalHarga.value = harga.value + 50000;
    } else {
      totalHarga.value = harga.value;
    }
  }

  void pilihMetode(String metode) {
    metodePembayaran.value = metode;
  }

  void pakaiPromo(String kode) {
    kodePromo.value = kode;
    // Dummy: diskon Rp 20.000
    totalHarga.value = (totalHarga.value - 20000).clamp(0, 99999999);
  }

  Future<void> bayarSekarang() async {
    // Seolah-olah panggil API

    Get.snackbar(
      "Sukses",
      "Pembayaran berhasil diproses (dummy)!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.teal.withOpacity(0.8),
      colorText: Colors.white,
      margin: EdgeInsets.all(12),
      borderRadius: 8,
    );
    Get.toNamed(Routes.PAYMENT_CHECKOUT);
  }

  Future<void> getData() async {
    try {
      final url = await baseUrl + apiGetDataBuyAllWhishlist;

      final result = await _restClient.getData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        wishLishData.value = result['data'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getPaymentData() async {
    try {
      final url = await baseUrl + apiGetPaymentList;

      final result = await _restClient.getData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        paymantListData.value = result['data'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  void toggleCheck(int index, bool value) {
    productChecked[index] = value;
    productChecked.refresh();
  }
}
