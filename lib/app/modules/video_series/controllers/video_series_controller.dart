import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class VideoSeriesController extends GetxController {
  //TODO: Implement VideoSeriesController

  final count = 0.obs;
  final restClient = RestClient();
  RxList<String> options = ["Semua", "CPNS", "BUMN", "Kedinasan", "PPPK"].obs;
  RxMap<String, Color> categoryColor =
      <String, Color>{
        "CPNS": Colors.teal,
        "BUMN": Colors.blueAccent,
        "Kedinasan": Colors.orangeAccent,
        "PPPK": Colors.redAccent,
      }.obs;
  RxMap<String, dynamic> optionsId =
      <String, dynamic>{
        "CPNS": 1,
        "BUMN": 2,
        "Kedinasan": 3,
        "PPPK": 4,
        "Semua": "",
      }.obs;
  List<Map<String, dynamic>> listVideo = <Map<String, dynamic>>[].obs;
  RxString selectedPaketKategori = "Semua".obs;
  RxInt currentPage = 0.obs;
  RxInt totalPage = 1.obs;
  @override
  void onInit() {
    super.onInit();
    initVideoSeries();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initVideoSeries() async {
    await fetchVideoData();
  }

  Future<void> fetchVideoData() async {
    final payload = {
      "perpage": "10",
      "menu_category_id": optionsId[selectedPaketKategori.value].toString(),
      "page": currentPage.value,
    };
    final response = await restClient.postData(
      url: baseUrl + apiListVideoSeries,
      payload: payload,
    );
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data']['data'],
    );
    print(payload);
    if (response['status'] == "success") {
      listVideo.assignAll(data);
      totalPage.value = (response['data']['total'] / 10).toInt();
      print(data);
    } else {
      Get.snackbar("Error", "Failed to fetch data");
    }
  }
}
