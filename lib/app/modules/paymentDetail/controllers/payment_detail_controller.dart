import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDetailController extends GetxController {
  var uuid = Get.arguments;
  RxString subPaketName = "".obs;
  RxMap<int, String> selectedSub = <int, String>{}.obs;
  RxMap<int, bool> checked = <int, bool>{}.obs;
  RxMap bimbelData = {}.obs;
  RxList otherBimbelData = [].obs;
  // var selectedSub = ''.obs; // bisa kosong kalau belum dipilih
  final selectedPaketPerCard = <int, Map<String, dynamic>>{}.obs;

  // daftar opsi sub

  RxString ovoNumber = "".obs;
  RxInt paymentMethodId = 0.obs;
  RxString paymentMethod = "".obs;
  RxString promoCodeName = "".obs;
  RxString paymentImage = "".obs;
  RxString paymentType = "".obs;
  RxInt baseHarga = 0.obs;
  RxInt promoAmount = 0.obs;
  RxInt parentId = 0.obs;
  RxBool isLoading = false.obs;
  // untuk state radio pilihan (sub bimbel)

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
  RxMap wishLishData = {}.obs;
  RxList paymantListData = [].obs;

  final TextEditingController promoController = TextEditingController();
  final TextEditingController ovoController = TextEditingController();
  var paketLainnya = "Bimbel SKD CPNS 2025 Batch 16".obs;
  var selectedPaketLainnya = "".obs;

  // contoh: simpan status checkbox di list

  var metodePembayaran = "".obs;
  var kodePromo = "".obs;
  RxString wishListFirstProduct = "".obs;
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
    print("xxxv ${paket.toString()}");
    selectedPaketPerCard[parentId] = paket;
    selectedPaketPerCard.refresh(); // biar Obx ke-update
  }

  void pilihMetode(String metode) {
    metodePembayaran.value = metode.replaceAll('_', ' ');
  }

  Future<void> bayarSekarang() async {
    // Seolah-olah panggil API
    notifHelper.show("Pembayaran berhasil diproses", type: 1);
    Get.toNamed(Routes.PAYMENT_CHECKOUT);
  }

  List<int> getSelectedItems() {
    return selectedPaketPerCard.values
        .map((paket) => paket["id"] as int)
        .toList();
  }

  Future<void> getData() async {
    final url = baseUrl + apiGetDetailBimbelNoevent + "/" + uuid;
    print("xxx ${url.toString()}");

    final result = await _restClient.getData(url: url);

    // cek status dulu, kalau success lanjut
    if (result["status"] == "success") {
      bimbelData.value = result["data"];
      parentId.value = result['data']['bimbel_parent_id'];
      baseHarga.value = result['data']['harga_fix'];
      final parent = result["data"]['bimbel_parent'];
      if (parent != null) {
        wishListFirstProduct.value = parent['name'] ?? '';
      } else {
        wishListFirstProduct.value = ''; // fallback kalau null
      }
      getOtherBimbel();
    } else {
      // kalau status bukan success, tampilkan pesan server
      print("Fetch failed: ${result['message']}");
      // bisa juga kasih notif ke user
      notifHelper.show(result['message'] ?? "Terjadi kesalahan", type: 0);
    }
  }

  Future<void> getOtherBimbel() async {
    final url = baseUrl + apiGetBimbelOther;
    print("xxx ${url.toString()}");

    final result = await _restClient.getData(url: url);

    if (result["status"] == "success") {
      final List allBimbel = result["data"] ?? [];

      // filter kecuali yang id == parentId.value
      otherBimbelData.value =
          allBimbel.where((bimbel) => bimbel['id'] != parentId.value).toList();

      print("Other Bimbel: ${otherBimbelData.value}");
    } else {
      print("Fetch failed: ${result['message']}");
      notifHelper.show(result['message'] ?? "Terjadi kesalahan", type: 0);
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
      print("Errorxx: $e");
    }
  }

  Future<void> getApplyCode() async {
    final url = await baseUrl + apiApplyBimbelVoucherCode;
    var payload = {
      "kode_promo": promoController.text,
      "amount": getTotalHargaFix(),
    };

    final result = await _restClient.postData(url: url, payload: payload);

    if (result == null) {
      notifHelper.show("Terjadi kesalahan jaringan", type: 0);
      return;
    }

    if (result["status"] == "success") {
      kodePromo.value = promoController.text;
      promoAmount.value = result['data']['nominal'];
      promoCodeName.value = result['data']['voucher_code'];
      promoController.clear();

      notifHelper.show(
        "Kode promo berhasil diterapkan: +${formatRupiah(promoAmount.value)}",
        type: 1,
      );
    } else {
      notifHelper.show(result["message"] ?? "Terjadi kesalahan", type: 0);
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

  void paymentSelected({
    required int id,
    required String methode,
    required String type,
    required String image,
  }) {
    print("XXXvs");
    paymentMethod.value = methode;
    paymentMethodId.value = id;
    paymentType.value = type;
    paymentImage.value = image;
    metodePembayaran.value = methode.replaceAll('_', ' ');
  }

  void createPayment() async {
    final payload = {
      "type": "bimbel",
      "total_amount": getTotalHargaFix(),
      "amount_diskon": promoAmount.value,
      "description": wishListFirstProduct.value,
      "bundling": true,
      "bimbel_id": parentId.value,
      "kode_promo": promoCodeName.value,
      "items": getSelectedItems(),
      "source": "",
      "useBalance": false,
      "payment_method_id": paymentMethodId.value,
      "payment_method": paymentMethod.value,
      "payment_type": paymentType.value,
      "mobile_number": ovoNumber.value,
    };

    print("xxxds${payload.toString()}");
    isLoading.value = true;
    final result = await _restClient.postData(
      url: baseUrl + apiCreatePayment,
      payload: payload,
    );

    if (result["status"] == "success") {
      final data = result['data'];
      print("Xxxc ${result["data"].toString()}");
      // pindah halaman checkout dulu
      Get.offNamed(Routes.PAYMENT_CHECKOUT, arguments: data['payment_id']);

      // cek jika ada invoice_url
      if (data.containsKey('invoice_url') && data['invoice_url'] != null) {
        final String url = data['invoice_url'];
        try {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            print("Tidak bisa buka link: $url");
          }
        } catch (e) {
          print("Error saat buka link: $e");
        }
      }
    } else {
      print("Error: ${result['message']}");
    }
    isLoading.value = false;
  }
}
