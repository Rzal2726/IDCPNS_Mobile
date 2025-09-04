import 'package:get/get.dart';

class DetailTryoutHarianController extends GetxController {
  //TODO: Implement DetailTryoutHarianController

  final count = 0.obs;
  RxList<String> instructions =
      [
        "Pastikan koneksi internet stabil.",
        "Jangan membuka tab lain saat mengerjakan tryout.",
        "Jangan menekan tombol Selesai saat mengerjakan soal, kecuali saat Anda telah selesai mengerjakan seluruh soal.",
        "Perhatikan sisa waktu ujian, sistem akan mengumpulkan jawaban saat waktu sudah selesai.",
        "Waktu ujian akan dimulai saat tombol 'Mulai Tryout' di klik.",
        "Jangan menutup/keluar dari halaman pengerjaan apabila Anda sudah menekan tombol 'Mulai Tryout', karena waktu akan terus berjalan dan Anda tidak dapat lagi mengerjakannya apabila waktu sudah habis.",
        "Kerjakan dengan jujur dan serius.",
      ].obs;
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
