import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class DetailMyBimbelController extends GetxController {
  final _restClient = RestClient();
  var uuid = Get.arguments;
  var paketName = "Bimbel SKD CPNS 2024 Batch 12".obs;
  var paketType = "Reguler".obs;
  var masaAktif = 178.obs; // hari aktif
  RxBool platinumZone = false.obs;
  RxMap bimbelData = {}.obs;
  RxMap rankBimbel = {}.obs;
  RxInt userRank = 0.obs;
  RxList jadwalKelas = [].obs;

  final count = 0.obs;
  @override
  void onInit() {
    getData();
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

  Future<void> getData() async {
    try {
      final url = await baseUrl + apiGetDetailBimbelSaya + "/" + uuid;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        bimbelData.value = result['data'];
        jadwalKelas.value = result['data']['bimbel']['events'];
        platinumZone.value = result['data']['ispremium'] == 1;

        getJadwalBimbel(id: bimbelData['user_id']);
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getJadwalBimbel({required int id}) async {
    try {
      final url = baseUrl + apiGetRankingBimbel + "/" + uuid;
      final result = await _restClient.postData(url: url);

      if (result["status"] == "success") {
        var data = result['data'];
        rankBimbel.value = data;

        // ambil list rank
        final listRank = data['data'] as List;

        // cari user_id yang sama dengan id yang dipassing
        final found = listRank.firstWhere(
          (item) => item['user_id'] == id,
          orElse: () => null,
        );

        if (found != null) {
          userRank.value = found['rank'];
        }
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
