import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class TryoutSayaController extends GetxController {
  //TODO: Implement TryoutSayaController
  final restClient = RestClient();
  RxMap<String, bool> isLoading = <String, bool>{"list": false}.obs;
  RxMap<String, Color> categoryColors =
      <String, Color>{"Premium": Colors.orange, "Gratis": Colors.teal}.obs;
  RxMap<String, Color> statusColors =
      <String, Color>{
        "Belum Dikerjakan": Colors.grey,
        "Sedang Dikerjakan": Colors.green,
      }.obs;
  RxMap<String, Color> menuColors =
      <String, Color>{
        "CPNS": Colors.teal,
        "BUMN": Colors.blueAccent,
        "Kedinasan": Colors.orangeAccent,
        "PPPK": Colors.redAccent,
      }.obs;
  RxList<String> options = ["Semua", "CPNS", "BUMN", "Kedinasan", "PPPK"].obs;
  List<Map<String, String>> optionsPengerjaan =
      <Map<String, String>>[
        {"isDone": "Semua", "value": ""},
        {"isDone": "Belum Dikerjakan", "value": "1"},
        {"isDone": "Sedang Dikerjakan", "value": "2"},
      ].obs;
  List<Map<String, String>> optionsHasil =
      <Map<String, String>>[
        {"isLulus": "Semua", "value": ""},
        {"isLulus": "Tidak Lulus", "value": "1"},
        {"isLulus": "Lulus", "value": "2"},
      ].obs;
  RxList<Map<dynamic, dynamic>> listData = <Map<dynamic, dynamic>>[].obs;
  RxList<Map<dynamic, dynamic>> listCategory =
      <Map<dynamic, dynamic>>[
        {"id": "", "menu": "Semua"},
      ].obs;
  RxString selectedPaketKategori = "Semua".obs;
  RxString selectedPengerjaan = "Semua".obs;
  RxString selectedHasil = "Semua".obs;
  RxString kategoriId = "".obs;
  RxString isDone = "".obs;
  RxString isLulus = "".obs;
  RxString search = "".obs;
  RxString selectedUuid = "".obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    initAll();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initAll() async {
    await fetchTryoutSaya();
    fetchKategori();
  }

  Future<void> fetchTryoutSaya() async {
    isLoading['list'] = true;
    final payload = {
      "perpage": "15",
      "isdone": int.tryParse(isDone.value),
      "islulus": int.tryParse(isLulus.value),
      "menu_category_id": int.tryParse(kategoriId.value),
      "search": search.value,
    };
    final response = await restClient.postData(
      url: baseUrl + apiGetTryoutSaya,
      payload: payload,
    );
    ;

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data']['data'],
    );
    listData.assignAll(data);
    isLoading['list'] = false;
  }

  void fetchKategori() async {
    final client = Get.find<RestClientProvider>();

    final response = await restClient.getData(url: baseUrl + apiGetCategory);

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    for (var item in data) {
      final exists = listCategory.any((e) => e['id'] == item['id']);
      if (!exists) {
        listCategory.add(item);
      }
    }
  }
}
