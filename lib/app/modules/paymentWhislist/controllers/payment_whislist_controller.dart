import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentWhislistController extends GetxController {
  // checkbox utama
  var bimbelChecked = false.obs;
  var tryoutChecked = false.obs; // <-- tambahan
  // sub-checkbox
  // var selectedSub = ''.obs; // bisa kosong kalau belum dipilih
  final selectedPaketPerCard = <int, Map<String, dynamic>>{}.obs;
  final box = GetStorage();
  // daftar opsi sub
  RxMap<int, bool> checked = <int, bool>{}.obs;

  RxString ovoNumber = "".obs;
  RxInt paymentMethodId = 0.obs;
  RxString paymentMethod = "".obs;
  RxString biayaAdminRaw = "".obs;
  RxString promoCodeName = "".obs;
  RxString paymentImage = "".obs;
  RxString paymentType = "".obs;
  RxInt baseHarga = 0.obs;
  RxInt promoAmount = 0.obs;
  RxInt biayaAdmin = 0.obs;
  // untuk state radio pilihan (sub bimbel)
  RxMap<int, String> selectedSub = <int, String>{}.obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingButton = false.obs;
  RxBool isLoadingHarga = false.obs;
  RxInt afiFromStorage = 0.obs;
  var ovoError = ''.obs;

  @override
  void onInit() async {
    await getData();
    await getPromoCodeFromStorage();
    await getPaymentData();
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

  Future<void> getPromoCodeFromStorage() async {
    afiFromStorage.value = 1;
    // baca dari box, kalau null atau kosong, default ke ""
    String storedValue = box.read('userAfi') ?? "";

    // kalau kosong string, pakai ""
    if (storedValue.isEmpty) storedValue = "";

    // set text ke TextEditingController
    promoController.text = storedValue;

    getApplyCode();
  }

  void pilihPaket(int parentId, Map<String, dynamic> paket) {
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

  List<Map<String, dynamic>> getSelectedItems() {
    return selectedPaketPerCard.values
        .map(
          (paket) => {
            "type": paket["type"], // ambil type (bimbel / tryout)
            "id": paket["id"], // ambil id
          },
        )
        .toList();
  }

  Future<void> getData() async {
    isLoading.value = true;
    try {
      final url = baseUrl + apiGetDataBuyAllWhishlist;
      final result = await _restClient.getData(url: url);
      print("wishlist response: $result");

      if (result["status"] == "success") {
        wishLishData.value = result["data"];

        if (result["data"].isNotEmpty) {
          final firstItem = result["data"][0];
          final productDetail = firstItem["productDetail"];

          // Set nama produk pertama
          if (firstItem["bimbel_parent_id"] != null) {
            wishListFirstProduct.value = productDetail["name"];
          } else {
            wishListFirstProduct.value = productDetail["formasi"];
          }
        }

        // ✅ Auto pilih semua paket tryout
        for (var item in result["data"]) {
          if (item["bimbel_parent_id"] == null) {
            final productDetail = item["productDetail"];
            pilihPaket(item["id"], {
              "type": "tryout",
              "id": productDetail?["id"],
              "harga_fix": productDetail?["harga_fix"],
            });
          }
        }

        isLoading.value = false;
      } else {
        wishLishData.clear();
        isLoading.value = false;
      }
    } catch (e) {
      print("Error fetch wishlist: $e");
      wishLishData.clear();
      isLoading.value = false;
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
    isLoadingHarga.value = true; // mulai loading
    print("xxxbb ${getTotalHargaFix().toString()}");
    final url = baseUrl + apiApplyWishListVoucherCode;
    var payload = {
      "kode_promo": promoController.text,
      "amount": getTotalHargaFix(),
    };

    final result = await _restClient.postData(url: url, payload: payload);

    if (result == null) {
      notifHelper.show("Terjadi kesalahan jaringan", type: 0);
      isLoadingHarga.value = false;
      return;
    }

    if (result["status"] == "success") {
      kodePromo.value = promoController.text;
      promoAmount.value = result['data']['nominal'];

      promoCodeName.value = result['data']['voucher_code'];
    } else {
      promoController.clear();
      kodePromo.value = '';
      promoAmount.value = 0;
      if (afiFromStorage.value != 1)
        notifHelper.show(result["message"] ?? "Terjadi kesalahan", type: 0);
    }
    afiFromStorage.value = 0;
    isLoadingHarga.value = false; // selesai loading
  }

  void clearPaymentSelection() {
    ovoNumber.value = "";
    ovoController.clear();
    paymentMethod.value = "";
    paymentMethodId.value = 0;
    paymentImage.value = "";
    paymentType.value = "";
    metodePembayaran.value = "";
    biayaAdmin.value = 0; // reset biaya admin juga
    ovoError.value = "";
    Get.back();
  }

  int calculateBiayaAdmin(String biayaAdminRaw) {
    // Hitung total paket
    final totalPaket = selectedPaketPerCard.values
        .map((paket) => (paket["harga_fix"] ?? 0) as int)
        .fold(0, (total, harga) => total + harga);

    final totalSebelumPromo = baseHarga.value + totalPaket;
    double adminNominal = 0;
    print(
      "xxxcc ${totalSebelumPromo.toString()} dam ${biayaAdminRaw.toString()}",
    );
    // Hitung biaya admin
    if (biayaAdminRaw.endsWith('%')) {
      final persen =
          double.tryParse(biayaAdminRaw.replaceAll('%', '').trim()) ?? 0.0;
      adminNominal = totalSebelumPromo * persen / 100;
    } else {
      adminNominal = double.tryParse(biayaAdminRaw) ?? 0.0;
    }
    print("xxcx ${adminNominal.toString()}");
    // Ambil PPN dari local storage
    final ppnPercent = double.tryParse(box.read("ppn") ?? "0") ?? 0.0;
    print("xxc ${ppnPercent.toString()}");
    // Total biaya admin termasuk PPN
    final totalAdmin = adminNominal * (1 + ppnPercent / 100);
    print("vddf ${totalAdmin.toString()}");
    // Return dibulatkan ke bawah
    return totalAdmin.floor();
  }

  void updateBiayaAdmin(String biayaAdminRaw) {
    // Hitung total paket
    final totalPaket = selectedPaketPerCard.values
        .map((paket) => (paket["harga_fix"] ?? 0) as int)
        .fold(0, (total, harga) => total + harga);

    final totalSebelumPromo = baseHarga.value + totalPaket;

    double adminNominal = 0;

    // Hitung biaya admin dulu
    if (biayaAdminRaw.endsWith('%')) {
      final persen =
          double.tryParse(biayaAdminRaw.replaceAll('%', '').trim()) ?? 0.0;
      adminNominal = totalSebelumPromo * persen / 100;
    } else {
      adminNominal = double.tryParse(biayaAdminRaw) ?? 0.0;
    }

    // Ambil PPN dari local storage
    final ppnPercent = double.tryParse(box.read("ppn") ?? "0") ?? 0.0;

    // Total biaya admin termasuk PPN
    final adminDenganPpn = adminNominal * (1 + ppnPercent / 100);

    // Masukkan ke RxInt dengan floor
    biayaAdmin.value = adminDenganPpn.floor();
  }

  int getTotalHargaFix() {
    print("xcc ${baseHarga.toString()}");
    final totalPaket = selectedPaketPerCard.values
        .map((paket) => (paket["harga_fix"] ?? 0) as int)
        .fold(0, (total, harga) => total + harga);

    final total = baseHarga.value + totalPaket;

    // tambahkan biaya admin yang sudah dihitung

    return total < 0 ? 0 : total;
  }

  Future<void> getAddOvoNumber() async {
    String text = ovoController.text;
    if (!text.startsWith("0")) {
      text = "0$text";
    }
    ovoNumber.value = text;
    // Optional: print the value to verify it's working
  }

  void createPayment() async {
    final payload = {
      "type": "wishlist",
      "total_amount": getTotalHargaFix() + biayaAdmin.value - promoAmount.value,
      "amount_diskon": promoAmount.value,
      "description": wishListFirstProduct.value,
      "bundling": true,
      "kode_promo": promoCodeName.value,
      "items": getSelectedItems(),
      "source": "",
      "useBalance": false,
      "payment_method_id": paymentMethodId.value,
      "payment_method": paymentMethod.value,
      "payment_type": paymentType.value,
      "mobile_number": ovoNumber.value,
    };
    print("xxx${payload.toString()}");

    final result = await _restClient.postData(
      url: baseUrl + apiCreatePayment,
      payload: payload,
    );

    if (result["status"] == "success") {
      final data = result['data'];

      // Pindah halaman dulu
      Get.offNamed(
        Routes.PAYMENT_CHECKOUT,
        arguments: [data['payment_id'], data['tanggal_kadaluarsa']],
      );

      // Cek apakah ada invoice_url
      if (data.containsKey('invoice_url') && data['invoice_url'] != null) {
        final url = data['invoice_url'];
        // buka link di browser
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
    } else {
      print("Error: $result");
    }
  }
}
