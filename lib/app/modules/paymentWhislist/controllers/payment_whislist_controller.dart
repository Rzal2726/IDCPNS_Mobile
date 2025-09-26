import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final url = await baseUrl + apiApplyWishListVoucherCode;
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
      // jika sukses
      kodePromo.value = promoController.text;
      promoAmount.value = result['data']['nominal'];
      promoCodeName.value = result['data']['voucher_code'];
      promoController.clear();
      notifHelper.show(
        "Kode promo berhasil diterapkan: +Rp ${promoAmount.value}",
        type: 1,
      );
    } else {
      notifHelper.show((result["message"] ?? "Terjadi kesalahan"), type: 0);
    }
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
  }

  void updateBiayaAdmin(String biayaAdminRaw) {
    final totalPaket = selectedPaketPerCard.values
        .map((paket) => (paket["harga_fix"] ?? 0) as int)
        .fold(0, (total, harga) => total + harga);

    final totalSebelumPromo = baseHarga.value + totalPaket;

    if (biayaAdminRaw.endsWith('%')) {
      // Hitung persen dari total sebelum promo
      final persen =
          double.tryParse(biayaAdminRaw.replaceAll('%', '').trim()) ?? 0.0;

      biayaAdmin.value =
          (totalSebelumPromo * persen / 100).round(); // hasil rupiah
    } else {
      // Langsung pakai nominal
      biayaAdmin.value = int.tryParse(biayaAdminRaw) ?? 0;
    }
  }

  int getTotalHargaFix() {
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
      Get.offNamed(Routes.PAYMENT_CHECKOUT, arguments: data['payment_id']);

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
