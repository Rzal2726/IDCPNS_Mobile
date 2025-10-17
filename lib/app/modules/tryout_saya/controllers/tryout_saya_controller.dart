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
  RxInt currentPage = 1.obs;
  RxInt totalPage = 1.obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    initAll();
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

  void goToPage(int page) {
    if (page >= 1 && page <= totalPage.value) {
      currentPage.value = page;
      fetchTryoutSaya();
      // panggil API fetch data di sini jika perlu
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      fetchTryoutSaya();
      // panggil API fetch data di sini
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchTryoutSaya();
      // panggil API fetch data di sini
    }
  }

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }

  Future<void> initAll() async {
    currentPage.value = 1;
    await fetchTryoutSaya();
    await fetchKategori();
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPage.value) {
      currentPage.value = page;
      fetchTryoutSaya();
      // panggil API fetch data di sini jika perlu
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      fetchTryoutSaya();
      // panggil API fetch data di sini
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchTryoutSaya();
      // panggil API fetch data di sini
    }
  }

  Future<void> fetchTryoutSaya() async {
    print("Page: ${currentPage.value.toString()}");
    print("Total Page: ${totalPage.value.toString()}");
    isLoading['list'] = true;
    final payload = {
      "perpage": "15",
      "page": currentPage.toString(),
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
    final Map<String, dynamic> pageData = Map<String, dynamic>.from(
      response['data'],
    );
    totalPage.value =
        ((pageData['total'] as int) / (pageData['per_page'] as int)).ceil();
    listData.assignAll(data);
    isLoading['list'] = false;
  }

  Future<void> fetchKategori() async {
    final response = await restClient.getData(url: baseUrl + apiGetCategory);

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    print(data);
    for (var item in data) {
      final exists = listCategory.any((e) => e['id'] == item['id']);
      if (!exists) {
        listCategory.add(item);
      }
    }
  }

  void aturUlang() {
    print("Kategori: ${listCategory}");
    selectedPaketKategori.value = "Semua";
    selectedPengerjaan.value = "Semua";
    selectedHasil.value = "Semua";
    kategoriId.value = "";
    isDone.value = "";
    isLulus.value = "";
  }
}
