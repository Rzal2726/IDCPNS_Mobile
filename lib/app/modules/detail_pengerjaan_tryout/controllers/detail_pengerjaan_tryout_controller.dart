import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/modules/detail_tryout_saya/controllers/detail_tryout_saya_controller.dart';

class DetailPengerjaanTryoutController extends GetxController {
  //TODO: Implement DetailPengerjaanTryoutController

  final count = 0.obs;
  final prevController = Get.find<DetailTryoutSayaController>();
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
  RxMap<String, dynamic> tryOutSaya = <String, dynamic>{}.obs;
  @override
  void onInit() async {
    super.onInit();
    await initPengerjaan();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initPengerjaan() async {
    await getDetailTryout();
  }

  Future<void> getDetailTryout() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/me/detail/${prevController.uuid}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        response.body['data'],
      );
      tryOutSaya.assignAll(data);
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }
}
