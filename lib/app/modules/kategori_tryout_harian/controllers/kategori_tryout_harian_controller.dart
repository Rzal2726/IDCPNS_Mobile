import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:intl/intl.dart';

class KategoriTryoutHarianController extends GetxController {
  //TODO: Implement KategoriTryoutHarianController

  late String CategoryUuid;
  final restClient = RestClient();
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> tryoutList = <Map<String, dynamic>>[].obs;
  RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    initTryout();
    checkMaintenance();
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
    CategoryUuid = await Get.arguments;
    await getList();
    await getKategori();
    loading.value = false;
  }

  Future<void> getKategori() async {
    final response = await restClient.getData(url: baseUrl + apiGetKategori);
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    categories.assignAll(data);
  }

  Future<void> getList() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetTryoutHarianList + CategoryUuid,
    );
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );

    print("Jawaban terbaru $data");
    // Ambil tanggal hari ini dalam format yyyy-MM-dd
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // Filter list berdasarkan field tanggal
    final filteredData =
        data.where((item) {
          final String? tanggal = item['tanggal']?.toString();
          if (tanggal == null) return false;

          final String tanggalOnly = tanggal.split(' ').first;

          return tanggalOnly == today;
        }).toList();
    print("data.length: ${data.length.toString()}");
    tryoutList.assignAll(filteredData);
  }

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
