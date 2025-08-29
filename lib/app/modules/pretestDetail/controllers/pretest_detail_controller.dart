import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class PretestDetailController extends GetxController {
  var isLoading = true.obs;
  var judul = "".obs;
  var jumlahSoal = 0.obs;
  var waktuMenit = 0.obs;

  var peraturan = <String>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    fetchPretestDetail();
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

  void fetchPretestDetail() async {
    await Future.delayed(Duration(seconds: 1)); // dummy loading
    judul.value = "Pertemuan 1 - TWK";
    jumlahSoal.value = 0;
    waktuMenit.value = 0;

    peraturan.value = [
      "Browser yang bisa digunakan hanya Google Chrome / Mozilla Firefox versi terbaru.",
      "Pastikan koneksi internet stabil.",
      "Jangan membuka tab lain saat mengerjakan Pretest.",
      "Jangan menekan tombol Selesai saat mengerjakan soal, kecuali saat Anda telah selesai mengerjakan seluruh soal.",
      "Perhatikan sisa waktu ujian, sistem akan mengumpulkan jawaban saat waktu sudah selesai.",
      "Waktu ujian akan dimulai saat tombol \"Mulai Pretest\" di klik.",
      "Jangan menutup/keluar dari halaman pengerjaan apabila Anda sudah menekan tombol \"Mulai Pretest\".",
      "Kerjakan dengan jujur dan serius.",
    ];
    isLoading.value = false;
  }

  void mulaiPretest() {
    Get.snackbar("Pretest", "Mulai pretest ${judul.value} (dummy)");
    Get.toNamed(Routes.PRETEST);
  }

  void lihatPanduan() {
    Get.snackbar("Panduan", "Menampilkan panduan pretest (dummy)");
    Get.toNamed(Routes.PRETEST_TOUR);
  }
}
