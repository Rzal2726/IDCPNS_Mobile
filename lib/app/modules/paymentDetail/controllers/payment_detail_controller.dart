import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentDetailController extends GetxController {
  // var uuid = Get.arguments[0];
  var hargaFix = Get.arguments[0];
  var dataPaket = Get.arguments[1];
  var dataPaymentMethode = Get.arguments[2];
  var otherBimbelData = Get.arguments[3];
  final box = GetStorage();
  RxString subPaketName = "".obs;
  RxMap<int, String> selectedSub = <int, String>{}.obs;
  RxMap<int, bool> checked = <int, bool>{}.obs;
  RxMap bimbelData = {}.obs;
  // RxList otherBimbelData = [].obs;
  // var selectedSub = ''.obs; // bisa kosong kalau belum dipilih
  final selectedPaketPerCard = <int, Map<String, dynamic>>{}.obs;

  // daftar opsi sub
  RxString biayaAdminRaw = "".obs;
  RxString ovoNumber = "".obs;
  RxInt paymentMethodId = 0.obs;
  RxString paymentMethod = "".obs;
  RxString promoCodeName = "".obs;
  RxString paymentImage = "".obs;
  RxString paymentType = "".obs;
  RxInt baseHarga = 0.obs;
  RxInt promoAmount = 0.obs;
  RxInt biayaAdmin = 0.obs;
  RxInt parentId = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingHarga =
      false.obs; // default true kalau mau skeleton muncul awal
  RxInt afiFromStorage = 0.obs;
  var ovoError = "".obs;

  // untuk state radio pilihan (sub bimbel)

  @override
  void onInit() async {
    refresh();
    super.onInit();
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
  RxString kodePromo = "".obs;
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

  Future<void> refresh() async {
    await getData();
    await getPromoCodeFromStorage();
    await getPaymentData();
  }

  void pilihPaket(int parentId, Map<String, dynamic> paket) {
    print("xxxv ${paket.toString()}");
    selectedPaketPerCard[parentId] = paket;
    selectedPaketPerCard.refresh(); // biar Obx ke-update
  }

  void pilihMetode(String metode) {
    metodePembayaran.value = metode.replaceAll('_', ' ');
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
    if (dataPaket["status"] == "success") {
      bimbelData.value = dataPaket["data"];
      parentId.value = dataPaket['data']['id'];
      baseHarga.value = hargaFix;
      print("xxbx ${baseHarga.toString()}");
      final parent = dataPaket["data"]['bimbel_parent'];
      if (parent != null) {
        wishListFirstProduct.value = parent['name'] ?? '';
      } else {
        wishListFirstProduct.value = ''; // fallback kalau null
      }
      // getOtherBimbel();
    } else {
      // kalau status bukan success, tampilkan pesan server
      print("Fetch failed: ${dataPaket['message']}");
      // bisa juga kasih notif ke user
      notifHelper.show(dataPaket['message'] ?? "Terjadi kesalahan", type: 0);
    }
  }

  Future<void> getPaymentData() async {
    try {
      // final url = await baseUrl + apiGetPaymentList;
      //
      // final result = await _restClient.getData(url: url);
      print("xcc ${dataPaymentMethode.toString()}");
      if (dataPaymentMethode["status"] == "success") {
        paymantListData.value = dataPaymentMethode['data'];
      }
    } catch (e) {
      print("Errorxx: $e");
    }
  }

  Future<void> getApplyCode() async {
    isLoadingHarga.value = true; // mulai loading
    print("xxcccc ${getTotalHargaFix().toString()}");
    final url = baseUrl + apiApplyBimbelVoucherCode;
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

  int getTotalHargaFix() {
    final totalPaket = selectedPaketPerCard.values
        .map((paket) => (paket["harga_fix"] ?? 0) as int)
        .fold(0, (total, harga) => total + harga);

    final total = baseHarga.value + totalPaket;
    print("xzcsd ${total.toString()}");
    return total < 0 ? 0 : total;
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
      "total_amount": getTotalHargaFix() + biayaAdmin.value - promoAmount.value,
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
      print("Xxxc ${result["data"]['tanggal_kadaluarsa'].toString()}");
      // pindah halaman checkout dulu
      Get.offNamed(
        Routes.PAYMENT_CHECKOUT,
        arguments: [data['payment_id'], data['tanggal_kadaluarsa']],
      );

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
