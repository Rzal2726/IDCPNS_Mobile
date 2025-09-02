import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class PeringkatTryoutController extends GetxController {
  //TODO: Implement PeringkatTryoutController

  final count = 0.obs;
  late String uuid;
  final restClient = RestClient();
  final searchController = TextEditingController();
  RxMap<String, dynamic> tryoutSaya = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> listPeringkat = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 1.obs;
  RxInt pesertaLulus = 0.obs;
  RxInt pesertTidakLulus = 0.obs;
  RxInt rank = 0.obs;
  RxInt total = 0.obs;
  RxInt totalPage = 0.obs;
  @override
  void onInit() {
    super.onInit();
    initPeringkat();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initPeringkat() async {
    uuid = await Get.arguments;
    await getDetailTryout();
    await getRanking();
  }

  Future<void> getDetailTryout() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutSaya + uuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryoutSaya.assignAll(data);
  }

  Future<void> getRanking() async {
    final payload = {
      "perpage": "10",
      "page": currentPage.toString(),
      "tryout_id": tryoutSaya['tryout']['uuid'].toString(),
      "search": searchController.text,
    };
    final response = await restClient.postData(
      url: baseUrl + apiRankingTryout + uuid,
      payload: payload,
    );

    print(response);
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data']['data'],
    );
    listPeringkat.assignAll(data);
    total.value = response['total_filtered'];
    rank.value = response['rank'];
    pesertaLulus.value = response['peserta_lulus'];
    pesertTidakLulus.value = response['peserta_tidak_lulus'];
    totalPage.value =
        (response['data']['total'] / response['data']['per_page']).floor();
  }
}
