import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class HasilTryoutHarianController extends GetxController {
  final count = 0.obs;
  late String uuid;
  final restClient = RestClient();
  RxMap<String, dynamic> nilaiChart = <String, dynamic>{}.obs;
  RxMap<String, dynamic> dataTryout = <String, dynamic>{}.obs;
  @override
  void onInit() {
    super.onInit();
    checkMaintenance();
    initHasil();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initHasil() async {
    uuid = await Get.arguments;
    await getNilai();
    await getDetail();
  }

  Future<void> getNilai() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetTryoutHarianHasil + uuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    nilaiChart.assignAll(data);
  }

  Future<void> getDetail() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetTryoutHarianDetail + uuid,
    );
    Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);
    print("hasi: $dataTryout");

    dataTryout.assignAll(data);
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
