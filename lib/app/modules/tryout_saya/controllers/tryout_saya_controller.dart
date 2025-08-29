import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

class TryoutSayaController extends GetxController {
  //TODO: Implement TryoutSayaController
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
    final client = Get.find<RestClientProvider>();
    final response = await client.post(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/me/list',
      {
        "perpage": "15",
        "isdone": int.tryParse(isDone.value),
        "islulus": int.tryParse(isLulus.value),
        "menu_category_id": int.tryParse(kategoriId.value),
        "search": search.value,
      },
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response.body['data']['data'],
      );
      listData.assignAll(data);
      print("IsDone: ${isDone.value}");
      print("IsLulus: ${isLulus.value}");
      print("kategoriId: ${kategoriId.value}");
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
    isLoading['list'] = false;
  }

  void fetchKategori() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/menu/category',
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response.body['data'],
      );
      for (var item in data) {
        final exists = listCategory.any((e) => e['id'] == item['id']);
        if (!exists) {
          listCategory.add(item);
        }
      }
      print('Data Kategori: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }
}
