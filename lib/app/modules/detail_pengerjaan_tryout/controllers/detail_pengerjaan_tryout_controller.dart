import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/modules/detail_tryout_saya/controllers/detail_tryout_saya_controller.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class DetailPengerjaanTryoutController extends GetxController {
  //TODO: Implement DetailPengerjaanTryoutController

  final count = 0.obs;
  final prevController = Get.find<DetailTryoutSayaController>();
  final restClient = RestClient();
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
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutSaya + prevController.uuid.value,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryOutSaya.assignAll(data);
  }
}
