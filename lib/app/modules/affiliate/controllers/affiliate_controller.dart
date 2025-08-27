import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AffiliateController extends GetxController {
  var totalKomisi = 0.obs;
  var komisiTersedia = 0.obs;
  var komisiDitarik = 0.obs;

  TextEditingController kodeController = TextEditingController(
    text: "E14F7E74",
  );
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

  void simpanKode() {
    // Tambahkan logika simpan kode
    Get.snackbar(
      "Sukses",
      "Kode berhasil disimpan",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
