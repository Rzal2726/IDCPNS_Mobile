import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class PaymentDetailController extends GetxController {
  final _restClient = RestClient();

  var id = Get.arguments[0];
  var idPaket = Get.arguments[1];

  RxBool bimbelChecked = false.obs;
  RxBool tryoutChecked = false.obs;

  RxString subPaketName = "".obs;
  RxMap<int, bool> checked = <int, bool>{}.obs;
  final selectedPaketPerCard = <int, Map<String, dynamic>>{}.obs;

  RxString ovoNumber = "".obs;
  RxInt paymentMethodId = 0.obs;
  RxString paymentMethod = "".obs;
  RxString paymentType = "".obs;
  RxInt baseHarga = 0.obs;

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

  RxMap bimbelData = {}.obs;
  RxList otherBimbelData = [].obs;
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

  void pilihMetode(String metode) {
    metodePembayaran.value = metode;
  }

  void pakaiPromo(String kode) {
    kodePromo.value = kode;
    // Dummy: diskon Rp 20.000
    // totalHarga.value = (totalHarga.value - 20000).clamp(0, 99999999);
  }

  Future<void> getData() async {
    try {
      // final url = baseUrl + apiGetDetailBimbelNoevent + "/" + id;
      final url = await baseUrl + apiGetDetailBimbel + "/" + id;
      final result = await _restClient.getData(url: url);
      print("wishlist response: $result");

      if (result["status"] == "success") {
        bimbelData.value = result['data'];
        getOherBimbel();
        print("xxx ${idPaket.toString()}");
        final List bimbelList = result['data']['bimbel'];

        final paket = bimbelList.firstWhere(
          (e) => e['id'].toString() == idPaket.toString(),
          orElse: () => null,
        );
        print("xxx ${bimbelList.toString()}");
        if (paket != null) {
          subPaketName.value = paket['name'];
          baseHarga.value = paket['harga_fix'];
        }
      } else {
        bimbelData.clear();
      }
    } catch (e) {
      print("Error fetch wishlist1: $e");
      bimbelData.clear();
    }
  }

  Future<void> getOherBimbel() async {
    try {
      final url = baseUrl + apiGetBimbelOther;

      final result = await _restClient.getData(url: url);
      print("wishlist response: $result");

      if (result["status"] == "success" && result["data"] is List) {
        // filter data yang id-nya sama dengan bimbelData['id']
        final filteredData =
            (result["data"] as List)
                .where((item) => item['id'] != bimbelData['id'])
                .toList();

        otherBimbelData.value = filteredData;
      } else {
        otherBimbelData.clear();
      }
    } catch (e) {
      print("Error fetch wishlist2: $e");
      otherBimbelData.clear();
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

  void pilihPaket(int parentId, Map<String, dynamic> paket) {
    selectedPaketPerCard[parentId] = paket;
    selectedPaketPerCard.refresh(); // biar Obx ke-update
  }

  List<int> getSelectedItems() {
    return selectedPaketPerCard.values
        .map((paket) => paket["id"] as int)
        .toList();
  }

  int getTotalHargaFix() {
    return (baseHarga.value +
        selectedPaketPerCard.values
            .map((paket) => paket["harga_fix"] as int)
            .fold(0, (total, harga) => total + harga));
    ;
  }

  void createPayment() async {
    final payload = {
      "type": "bimbel",
      "total_amount": getTotalHargaFix(),
      "amount_diskon": 0,
      "description": bimbelData['name'] ?? "",
      "bundling": true,
      "bimbel_parent_id": bimbelData['id'] ?? 0,
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

  void paymentSelected({
    required int id,
    required String methode,
    required String type,
  }) {
    paymentMethod.value = methode;
    paymentMethodId.value = id;
    paymentType.value = type;
  }
}
