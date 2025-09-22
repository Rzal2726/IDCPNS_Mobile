import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class BimbelController extends GetxController {
  final _restClient = RestClient();
  RxList bimbelData = [].obs;

  final TextEditingController searchController = TextEditingController();

  var selectedUuid = ''.obs;
  var searchQuery = ''.obs;
  final count = 0.obs;

  RxString selectedEventKategori = "Semua".obs;
  final options = <Map<String, dynamic>>[].obs;
  RxInt selectedKategoriId = 0.obs; // RxnInt karena bisa null
  // page
  RxInt currentPage = 1.obs;
  RxInt totalPages = 0.obs;
  RxInt totalPage = 0.obs;

  @override
  void onInit() {
    getBimbel();
    getKategori();
    super.onInit();
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

  void searchPaket(String query) {
    searchQuery.value = query;
    // Dummy: hanya update query, belum filter real.
  }

  Future<void> getBimbel({
    String? menuCategoryId,
    String? submenuCategoryId,
    String? search,
    int? page,
  }) async {
    try {
      final url = baseUrl + apiGetBimbel;

      var payload = {
        "perpage": 5, // int
        "menu_category_id":
            selectedKategoriId.value.toString() == "0"
                ? ""
                : selectedKategoriId.value.toString(),
        "submenu_category_id": submenuCategoryId ?? "",
        "search": search ?? "",
        "page": page ?? 0,
      };

      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {
        var data = result['data']['data'];
        bimbelData.value = data;

        totalPage.value = result['data']['last_page'];
      }
    } catch (e) {
      print("Error getBimbel: $e");
    }
  }

  Future<void> getKategori() async {
    try {
      final url = baseUrl + apiGetKategori;
      final result = await _restClient.getData(url: url);

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

  // page
  void goToPage(int page) {
    if (page >= 1 && page <= totalPage.value) {
      currentPage.value = page;
      getBimbel(
        page: currentPage.value,
        menuCategoryId: selectedKategoriId.value?.toString(),
      );
      // panggil API fetch data di sini jika perlu
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      getBimbel(
        page: currentPage.value,
        menuCategoryId: selectedKategoriId.value?.toString(),
      );
      // panggil API fetch data di sini
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      getBimbel(
        page: currentPage.value,
        menuCategoryId: selectedKategoriId.value?.toString(),
      );
      // panggil API fetch data di sini
    }
  }

  Future<void> checkMaintenance() async {
    final response = await _restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
