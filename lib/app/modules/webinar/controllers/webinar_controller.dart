import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class WebinarController extends GetxController {
  //TODO: Implement WebinarController

  final count = 0.obs;
  final restClient = RestClient();
  final options = <Map<String, dynamic>>[].obs;
  RxInt selectedKategoriId = 0.obs; // RxnInt karena bisa null
  RxString selectedEventKategori = "Semua".obs;
  RxMap<String, bool> loading = <String, bool>{}.obs;
  RxMap<String, Color> categoryColor =
      <String, Color>{
        "CPNS": Colors.teal,
        "BUMN": Colors.blueAccent,
        "Kedinasan": Colors.orangeAccent,
        "PPPK": Colors.redAccent,
      }.obs;
  RxList<Map<String, dynamic>> categoryList =
      <Map<String, dynamic>>[
        {"menu": "Semua", "id": ""},
      ].obs;
  RxList<Map<String, dynamic>> webinarList = <Map<String, dynamic>>[].obs;
  // RxString selectedKategori = "".obs;
  RxInt currentPage = 1.obs;
  RxInt totalPage = 1.obs;
  RxInt perPage = 5.obs;
  @override
  void onInit() {
    super.onInit();
    initEbook();
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
      getWebinar();
      // panggil API fetch data di sini jika perlu
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      getWebinar();
      // panggil API fetch data di sini
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      getWebinar();
      // panggil API fetch data di sini
    }
  }

  Future<void> initEbook() async {
    await getWebinar();
    await getCategoryList();
    await getKategori();
  }

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }

  Future<void> getWebinar() async {
    loading['webinar'] = true;
    final payload = {
      "perpage": perPage.value,
      "menu_category_id": selectedKategoriId.value,
    };
    final response = await restClient.postData(
      url:
          baseUrl + apiGetWebinarList + "?page=" + currentPage.value.toString(),
      payload: payload,
    );

    List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(
      response['data']['data'],
    );
    Map<String, dynamic> dataPage = Map<String, dynamic>.from(response['data']);
    totalPage.value = (dataPage['total'] / perPage.value as double).ceil();
    webinarList.assignAll(dataList);
    loading['webinar'] = false;
  }

  Future<void> getKategori() async {
    try {
      final url = baseUrl + apiGetKategori;
      final result = await restClient.getData(url: url);

      if (result["status"] == "success") {
        final data =
            (result['data'] as List)
                .map((e) => {"id": e['id'], "menu": e['menu']})
                .toList();

        // Tambahin opsi "Semua" di paling atas, id = "0"
        options.assignAll([
          {"id": 0, "menu": "Semua"},
          ...data,
        ]);
        print("XXX ${options.toString()}");
      }
    } catch (e) {
      print("Error getKategori: $e");
    }
  }

  Future<void> getCategoryList() async {
    print("categoryList: $categoryList");
    final response = await restClient.getData(url: baseUrl + apiGetCategory);

    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    categoryList.addAll(data);
    print(data);
    print("categoryList: $categoryList");
    print("categoryList: $data");
  }
}
