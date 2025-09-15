import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class DetailTryoutHarianController extends GetxController {
  //TODO: Implement DetailTryoutHarianController

  final count = 0.obs;
  late String uuid;
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
  RxMap<String, dynamic> dataTryout = <String, dynamic>{}.obs;
  RxBool loading = true.obs;
  @override
  void onInit() {
    super.onInit();
    initTryout();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initTryout() async {
    loading.value = true;
    uuid = await Get.arguments;
    await getDetail();
    loading.value = false;
  }

  Future<void> getDetail() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetTryoutHarianDetail + uuid,
    );
    Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);
    dataTryout.assignAll(data);
  }
}
