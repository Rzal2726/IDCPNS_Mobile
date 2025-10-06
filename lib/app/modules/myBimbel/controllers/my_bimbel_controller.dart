import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class MyBimbelController extends GetxController {
  final _restClient = RestClient();
  var searchText = ''.obs;
  RxMap listBimbel = {}.obs;
  RxBool isLoading = false.obs;
  RxInt selectedKategoriId = 0.obs; // RxnInt karena bisa null
  final options = <Map<String, dynamic>>[].obs;
  final TextEditingController searchController = TextEditingController();
  RxString selectedEventKategori = "Semua".obs;
  RxBool showSkeleton = true.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 0.obs;
  RxInt totalPage = 0.obs;

  final count = 0.obs;
  @override
  void onInit() {
    Future.delayed(Duration(seconds: 5), () {
      showSkeleton.value = false;
    });
    getData();
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

  void doSearch() {
    notifHelper.show('Fitur pencarian belum tersedia', type: 0);
  }

  Future<void> getData({
    int? page,
    String? menuCategoryId,
    String? submenuCategoryId,
    String? search,
  }) async {
    isLoading.value = true;
    try {
      final url = await baseUrl + apiGetMyBimbel;
      var payload = {
        "page": page ?? 0,
        "perpage": 10, // int
        "menu_category_id":
            selectedKategoriId.value.toString() == "0"
                ? ""
                : selectedKategoriId.value.toString(),
        "submenu_category_id": submenuCategoryId ?? "",
        "search": search ?? "",
      };
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        var data = result['data'];
        listBimbel.value = data;
        totalPage.value = data['last_page'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    } finally {
      isLoading.value = false;
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
}
