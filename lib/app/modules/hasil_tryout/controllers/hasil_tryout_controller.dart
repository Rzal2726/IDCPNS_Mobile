import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class HasilTryoutController extends GetxController {
  //TODO: Implement HasilTryoutController

  final count = 0.obs;
  late String uuid;
  final restClient = RestClient();
  RxMap<String, dynamic> nilaiChart = <String, dynamic>{}.obs;
  RxMap<String, dynamic> tryOutSaya = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> statistic = <Map<String, dynamic>>[].obs;
  @override
  void onInit() {
    super.onInit();
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
    await getDetailTryout();
    await getNilai();
  }

  Future<void> getNilai() async {
    final client = Get.find<RestClientProvider>();
    final response = await restClient.getData(
      url: baseUrl + apiGetNilaiSaya + uuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    nilaiChart.assignAll(data);
  }

  Future<void> getDetailTryout() async {
    final client = Get.find<RestClientProvider>();
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutSaya + uuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryOutSaya.assignAll(data);
  }
}
