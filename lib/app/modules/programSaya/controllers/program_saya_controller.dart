import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class ProgramSayaController extends GetxController {
  final _restClient = RestClient();
  RxList bimbelData = [].obs;
  RxList tryoutData = [].obs;
  RxInt selectedTab = 0.obs;
  RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  RxInt selectedKategoriId = 0.obs;
  final options = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 0.obs;
  RxInt totalPage = 0.obs;
  RxString selectedEventKategori = "Semua".obs;

  // 🔹 daftar program (sementara hardcode, nanti bisa diisi dari API)

  @override
  void onInit() {
    getTryout();
    getKategori();
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

  // ganti tab
  void changeTab(int index) {
    selectedTab.value = index;
  }

  // update pencarian
  void updateSearch(String value) {
    searchQuery.value = value;
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

  void getData({int page = 1, String search = ""}) {
    if (selectedTab.value == 0) {
      getTryout(page: page, search: search); // fetch Tryout
    } else if (selectedTab.value == 1) {
      getBimbel(page: page, search: search); // fetch Bimbel
    }
  }

  // pagination
  void goToPage(int page) {
    if (page >= 1 && page <= totalPage.value) {
      currentPage.value = page;
      getData(page: currentPage.value, search: searchController.text);
      // panggil API fetch data di sini jika perlu
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      getData(page: currentPage.value, search: searchController.text);
      // panggil API fetch data di sini
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      getData(page: currentPage.value, search: searchController.text);
      // panggil API fetch data di sini
    }
  }

  void searchData() {
    String query = searchController.text;
    currentPage.value = 1; // reset ke page 1 saat search

    if (selectedTab.value == 0) {
      getTryout(page: 1, search: query);
    } else if (selectedTab.value == 1) {
      getBimbel(page: 1, search: query);
    }
  }

  Future<void> getBimbel({
    int? page,
    String? search,
    String? submenuCategoryId,
  }) async {
    try {
      final url = await baseUrl + apiGetMyBimbel;
      var payload = {
        "page": page ?? 0,
        "perpage": 10,
        "search": search ?? " ",
        "menu_category_id": submenuCategoryId ?? "",
      };
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        bimbelData.value = result['data']['data'];
        totalPage.value = result['data']['last_page'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getTryout({
    int? page,
    String? search,
    String? submenuCategoryId,
  }) async {
    try {
      final url = await baseUrl + apiGetTryoutSaya;
      var payload = {
        "page": page ?? 0,
        "perpage": 10,
        "search": search ?? " ",
        "menu_category_id": submenuCategoryId ?? "",
      };
      print('xxx $payload');
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        tryoutData.value = result['data']['data'];
        totalPage.value = result['data']['last_page'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
