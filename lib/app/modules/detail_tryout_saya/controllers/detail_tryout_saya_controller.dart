import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

class DetailTryoutSayaController extends GetxController {
  //TODO: Implement DetailTryoutSayaController

  final count = 0.obs;
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
      '/tryout/formasi/{uuid}',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void getNilai() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/tryout/nilai/detail/{uuid}',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void getStatsNilai() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/tryout/waktu/detail/{uuid}',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void getServerTime() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/general/server-time',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void getInstansi() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/general/instansi/{category_id}',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void getJabatan() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/general/jabatan/{category_id}',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }
}
