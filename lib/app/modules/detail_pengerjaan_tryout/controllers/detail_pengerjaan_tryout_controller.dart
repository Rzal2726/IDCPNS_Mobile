import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

class DetailPengerjaanTryoutController extends GetxController {
  //TODO: Implement DetailPengerjaanTryoutController

  final count = 0.obs;
  final List<String> instructions = [
    "Pastikan koneksi internet stabil.",
    "Jangan membuka tab lain saat mengerjakan tryout.",
    "Jangan menekan tombol Selesai saat mengerjakan soal, kecuali saat Anda telah selesai mengerjakan seluruh soal.",
    "Perhatikan sisa waktu ujian, sistem akan mengumpulkan jawaban saat waktu sudah selesai.",
    "Waktu ujian akan dimulai saat tombol 'Mulai Tryout' di klik.",
    "Jangan menutup/keluar dari halaman pengerjaan apabila Anda sudah menekan tombol 'Mulai Tryout', karena waktu akan terus berjalan dan Anda tidak dapat lagi mengerjakannya apabila waktu sudah habis.",
    "Kerjakan dengan jujur dan serius.",
  ];
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

  void getDetailTryout() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/tryout/me/detail/{uuid}',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }
}
