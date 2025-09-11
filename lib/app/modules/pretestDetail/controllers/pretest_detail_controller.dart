import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class PretestDetailController extends GetxController {
  final _restClient = RestClient();
  var isLoading = true.obs;
  var judul = "".obs;
  var jumlahSoal = 0.obs;
  var waktuMenit = 0.obs;
  final Map item = Get.arguments['item'];
  var uuid = Get.arguments['uuidParent'];
  var peraturan =
      <String>[
        "Browser yang bisa digunakan hanya Google Chrome / Mozilla Firefox versi terbaru.",
        "Pastikan koneksi internet stabil.",
        "Jangan membuka tab lain saat mengerjakan Pretest.",
        "Jangan menekan tombol Selesai saat mengerjakan soal, kecuali saat Anda telah selesai mengerjakan seluruh soal.",
        "Perhatikan sisa waktu ujian, sistem akan mengumpulkan jawaban saat waktu sudah selesai.",
        "Waktu ujian akan dimulai saat tombol \"Mulai Pretest\" di klik.",
        "Jangan menutup/keluar dari halaman pengerjaan apabila Anda sudah menekan tombol \"Mulai Pretest\".",
        "Kerjakan dengan jujur dan serius.",
      ].obs;
  RxList bimbelData = [].obs;

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

  // Future<void> getData() async {
  //   try {
  //     final url = await baseUrl + apiGetDetailBimbelSaya + "/" + uuid;
  //
  //     final result = await _restClient.getData(url: url);
  //     if (result["status"] == "success") {
  //       bimbelData.value = result['data'];
  //     }
  //   } catch (e) {
  //     print("Error polling email verification: $e");
  //   }
  // }

  void mulaiPretest() {
    // print("xxx ${item.toString()}");
    Get.toNamed(
      Routes.PRETEST,
      arguments: {"uuidParent": uuid, "uuid": item['uuid']},
    );
    print("xxx ${item['uuid']}");
  }

  void lihatPanduan() {
    Get.snackbar("Panduan", "Menampilkan panduan pretest (dummy)");
    Get.toNamed(Routes.PRETEST_TOUR);
  }
}
