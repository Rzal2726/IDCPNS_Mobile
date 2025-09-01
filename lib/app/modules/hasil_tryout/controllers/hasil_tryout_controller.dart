import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

class HasilTryoutController extends GetxController {
  //TODO: Implement HasilTryoutController

  final count = 0.obs;
  late String uuid;
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
    initStatistic();
  }

  Future<void> getNilai() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/nilai/detail/${uuid}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        response.body['data'],
      );
      nilaiChart.assignAll(data);
      print('Data Nilai: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> getDetailTryout() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/me/detail/${uuid}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        response.body['data'],
      );
      tryOutSaya.assignAll(data);
      print('Data Detail: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void initStatistic() {
    statistic.assignAll(nilaiChart['statistic']);
  }
}
