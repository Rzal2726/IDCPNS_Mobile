import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class DetailMyBimbelController extends GetxController {
  final _restClient = RestClient();
  var uuid = Get.arguments;
  var paketName = "Bimbel SKD CPNS 2024 Batch 12".obs;
  var paketType = "Reguler".obs;
  var masaAktif = 178.obs; // hari aktif
  var platinumZone = true.obs;
  RxMap bimbelData = {}.obs;
  RxMap rankBimbel = {}.obs;
  RxInt userRank = 0.obs;
  var jadwalKelas = <Map<String, String>>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    getData();
    jadwalKelas.value = [
      {
        "judul": "Pertemuan 1 - TWK",
        "hari": "Rabu",
        "tanggal": "27 Agustus 2025",
        "jam": "19:30 WIB",
      },
      {
        "judul": "Pertemuan 2 - TKP",
        "hari": "Senin",
        "tanggal": "13 Januari 2025",
        "jam": "19:30 WIB",
      },
      {
        "judul": "Pertemuan 3 - TKP",
        "hari": "Selasa",
        "tanggal": "14 Januari 2025",
        "jam": "19:30 WIB",
      },
      {
        "judul": "Pertemuan 4 - TIU",
        "hari": "Rabu",
        "tanggal": "15 Januari 2025",
        "jam": "19:30 WIB",
      },
    ];
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
        getJadwalBimbel(id: bimbelData['user_id']);
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getJadwalBimbel({required int id}) async {
    try {
      final url = baseUrl + apiGetJadwalBimbelSaya + "/" + uuid;
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
