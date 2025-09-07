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
  final selectedPaketPerCard = <int, Map<String, dynamic>>{}.obs;

  // daftar opsi sub
  RxMap<int, bool> checked = <int, bool>{}.obs;

  RxString ovoNumber = "".obs;
  RxInt paymentMethodId = 0.obs;
  RxString paymentMethod = "".obs;
  RxString paymentType = "".obs;
  RxInt baseHarga = 0.obs;
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

  void pilihPaket(int parentId, Map<String, dynamic> paket) {
    selectedPaketPerCard[parentId] = paket;
    selectedPaketPerCard.refresh(); // biar Obx ke-update
  }

  void pilihMetode(String metode) {
    metodePembayaran.value = metode;
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

  List<int> getSelectedItems() {
    return selectedPaketPerCard.values
        .map((paket) => paket["id"] as int)
        .toList();
  }

  Future<void> getData() async {
    try {
      final url = baseUrl + apiGetDataBuyAllWhishlist;

      final result = await _restClient.getData(url: url);
      print("wishlist response: $result");

      if (result["status"] == "success") {
        wishLishData.value = result["data"];
        print("xxx ${wishLishData.toString()}");
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

  int getTotalHargaFix() {
    return (baseHarga.value +
        selectedPaketPerCard.values
            .map((paket) => paket["harga_fix"] as int)
            .fold(0, (total, harga) => total + harga));
    ;
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

  void createPayment() async {
    final payload = {
      "type": "bimbel",
      "total_amount": getTotalHargaFix(),
      "amount_diskon": 0,
      "description": "",
      "bundling": true,
      "bimbel_parent_id": 0,
      "kode_promo": "",
      "items": getSelectedItems(),
      "source": "",
      "useBalance": false,
      "payment_method_id": paymentMethodId.value,
      "payment_method": paymentMethod.value,
      "payment_type": paymentType.value,
      "mobile_number": ovoNumber.value,
    };
    print("xxx ${payload.toString()}");
    // final response = await _restClient.postData(
    //   url: baseUrl + apiCreatePayment,
    //   payload: payload,
    // );

    //  Get.toNamed(Routes.PAYMENT_CHECKOUT);
  }
}
