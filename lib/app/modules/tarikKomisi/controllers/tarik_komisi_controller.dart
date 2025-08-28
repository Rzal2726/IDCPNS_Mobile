import 'package:get/get.dart';

class TarikKomisiController extends GetxController {
  final List<String> informationPoints = [
    'Minimal penarikan komisi adalah Rp.500.000',
    'Biaya Admin setiap penarikan adalah Rp.4.950',
    'Pastikan komisi yang ditarik tidak lebih dari Komisi Tersedia',
    'Penarikan komisi akan diproses 3 Hari kerja (Tergantung antrian penarikan)',
  ];
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

  void increment() => count.value++;
}
