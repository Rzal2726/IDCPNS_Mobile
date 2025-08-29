import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class PaymentDetailController extends GetxController {
  var paketUtama = "Bimbel SKD CPNS 2024 Batch 12".obs;
  var paketUtamaTipe = "Reguler".obs;

  var paketLainnya = "Bimbel SKD CPNS 2025 Batch 16".obs;
  var selectedPaketLainnya = "".obs;

  var harga = 199000.obs;
  var totalHarga = 199000.obs;

  var metodePembayaran = "".obs;
  var kodePromo = "".obs;

  final count = 0.obs;
  @override
  void onInit() {
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
}
