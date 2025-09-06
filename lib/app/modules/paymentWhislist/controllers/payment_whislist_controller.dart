import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class PaymentWhislistController extends GetxController {
  // checkbox utama
  var bimbelChecked = false.obs;
  var tryoutChecked = false.obs; // <-- tambahan
  // sub-checkbox
  // var selectedSub = ''.obs; // bisa kosong kalau belum dipilih

  // daftar opsi sub
  RxMap<int, bool> checked = <int, bool>{}.obs;

  RxString ovoNumber = "".obs;

  // untuk state radio pilihan (sub bimbel)
  RxMap<int, String> selectedSub = <int, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
    getPaymentData();
    super.onInit();
    // Dummy data hardcode
    // Tambahkan properti reactive untuk checkbox & radio
  }

  final _restClient = RestClient();
  RxList wishLishData = [].obs;
  RxList paymantListData = [].obs;

  final TextEditingController promoController = TextEditingController();
  final TextEditingController ovoController = TextEditingController();
  var paketLainnya = "Bimbel SKD CPNS 2025 Batch 16".obs;
  var selectedPaketLainnya = "".obs;

  // contoh: simpan status checkbox di list
  var harga = 199000.obs;
  var totalHarga = 199000.obs;

  var metodePembayaran = "".obs;
  var kodePromo = "".obs;
  final count = 0.obs;

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
      final url = baseUrl + apiGetDataBuyAllWhishlist;

      final result = await _restClient.getData(url: url);
      print("wishlist response: $result");

      if (result["status"] == "success" && result["data"] is List) {
        wishLishData.value = result["data"];

        // init state (checkbox & radio) sesuai data
        for (var item in wishLishData) {
          checked[item["id"]] = false;
          selectedSub[item["id"]] = "";
        }
      } else {
        wishLishData.clear();
      }
    } catch (e) {
      print("Error fetch wishlist: $e");
      wishLishData.clear();
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

  Future<void> getApplyCode() async {
    try {
      final url = await baseUrl + apiApplyBimbelVoucherCode;
      var payload = {"kode_promo": promoController.text, "amount": 1000};
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        Get.snackbar("Berhasil", "voucher berhasil");
        promoController.clear();
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getAddOvoNumber() async {
    String text = ovoController.text;
    if (!text.startsWith("0")) {
      text = "0$text";
    }
    ovoNumber.value = text;
    // Optional: print the value to verify it's working
    print('OVO number saved: ${ovoNumber.value}');
  }

  // void createPayment() async {
  //   final payload = {
  //     "type": "tryout",
  //     "total_amount": totalHarga.value,
  //     "amount_diskon": diskon.value,
  //     "description": dataTryout['formasi'],
  //     "bundling": true,
  //     "tryout_formasi_id": dataTryout['id'],
  //     "kode_promo": promoCode.value,
  //     "items": itemsId,
  //     "source": "",
  //     "useBalance": false,
  //     "payment_method_id": selectedPaymentMethod['id'],
  //     "payment_method": selectedPaymentMethod['code'],
  //     "payment_type": selectedPaymentType.value,
  //     "mobile_number": ovoNumber.value,
  //   };
  //   final response = await restClient.postData(
  //     url: baseUrl + apiCreatePayment,
  //     payload: payload,
  //   );
  //
  //   final Map<String, dynamic> data = Map<String, dynamic>.from(
  //     response['data'],
  //   );
  //   transactionData.assignAll(data);
  //   Get.offNamed("/tryout-checkout");
  // }
}
