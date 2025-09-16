import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class WebinarController extends GetxController {
  //TODO: Implement WebinarController

  final count = 0.obs;
  final restClient = RestClient();
  RxMap<String, bool> loading = <String, bool>{}.obs;
  RxMap<String, Color> categoryColor =
      <String, Color>{
        "CPNS": Colors.teal,
        "BUMN": Colors.blueAccent,
        "Kedinasan": Colors.orangeAccent,
        "PPPK": Colors.redAccent,
      }.obs;
  RxList<Map<String, dynamic>> categoryList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> webinarList = <Map<String, dynamic>>[].obs;
  RxString selectedKategori = "".obs;
  @override
  void onInit() {
    super.onInit();
    initEbook();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initEbook() async {
    await getWebinar();
    await getCategoryList();
  }

  Future<void> getWebinar() async {
    loading['webinar'] = true;
    final payload = {"perpage": 10, "menu_category_id": selectedKategori.value};
    final response = await restClient.postData(
      url: baseUrl + apiGetWebinarList,
      payload: payload,
    );

    List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(
      response['data']['data'],
    );
    webinarList.assignAll(dataList);
    loading['webinar'] = false;
  }

  Future<void> getCategoryList() async {
    final response = await restClient.getData(url: baseUrl + apiGetCategory);

    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    categoryList.assignAll(data);
    print(data);
  }
}
