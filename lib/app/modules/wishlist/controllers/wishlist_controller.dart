import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class WishlistController extends GetxController {
  final _restClient = RestClient();
  var searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();
  RxMap whistlistData = {}.obs;
  final options = <Map<String, dynamic>>[].obs;
  final ProductOptions =
      <Map<String, dynamic>>[
        {"id": 0, "menu": "Semua"},
        {"id": 1, "menu": "Tryout"},
        {"id": 2, "menu": "Bimbel"},
      ].obs;
  RxInt selectedKategoriId = 0.obs; // RxnInt karena bisa null
  RxInt selectedProductiId = 0.obs; // RxnInt karena bisa null
  RxString selectedEventKategori = "Semua".obs;
  RxString selectedEventProduct = "Semua".obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 0.obs;
  RxInt totalPage = 0.obs;
  RxBool showSkeleton = true.obs;
  @override
  void onInit() {
    Future.delayed(Duration(seconds: 5), () {
      showSkeleton.value = false;
    });
    getWhislist();
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

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPage.value) {
      currentPage.value = page;
      getWhislist(
        page: currentPage.value,
        menuCategoryId: selectedKategoriId.value?.toString(),
        produk: selectedEventProduct.value,
      );
      // panggil API fetch data di sini jika perlu
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      getWhislist(
        page: currentPage.value,
        menuCategoryId: selectedKategoriId.value?.toString(),
        produk: selectedEventProduct.value,
      );
      // panggil API fetch data di sini
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      getWhislist(
        page: currentPage.value,
        menuCategoryId: selectedKategoriId.value?.toString(),
        produk: selectedEventProduct.value,
      );
      // panggil API fetch data di sini
    }
  }

  Future<void> getWhislist({
    String? menuCategoryId,
    String? produk,
    String? search,
    int? page,
  }) async {
    try {
      final url = await baseUrl + apiGetwhislist;
      var payload = {
        "perpage": 10, // int
        "menu_category_id":
            selectedKategoriId.value.toString() == "0"
                ? ""
                : selectedKategoriId.value.toString(),
        "product": (produk ?? " ").toLowerCase(),
        "search": search ?? " ",
        "params": (page ?? 0).toString(),
      };

      print("xxx $payload");
      final result = await _restClient.postData(url: url, payload: payload);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        whistlistData.value = result['data'];
        print("xxx ${result}");
        totalPage.value = result['data']['last_page'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
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
}
