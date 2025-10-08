import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class CommisionDetailController extends GetxController {
  final _restClient = RestClient();
  RxMap komisiDetailData = {}.obs;
  final TextEditingController searchController = TextEditingController();
  RxInt currentPage = 1.obs;
  RxInt totalPages = 0.obs;
  RxInt totalPage = 0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    refresh();
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

  Future<void> refresh() async {
    searchController.clear();
    await getRincianKomisi();
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPage.value) {
      currentPage.value = page;
      getRincianKomisi(page: currentPage.value, search: searchController.text);
      // panggil API fetch data di sini jika perlu
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      getRincianKomisi(page: currentPage.value, search: searchController.text);
      // panggil API fetch data di sini
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      getRincianKomisi(page: currentPage.value, search: searchController.text);
      // panggil API fetch data di sini
    }
  }

  Future<void> getRincianKomisi({int? page, String? search}) async {
    try {
      isLoading.value = true; // mulai loading
      final url = await baseUrl + apiGetRincianKomisi;

      var payload = {"perpage": 10, "search": search ?? "", "page": page ?? 0};
      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {
        var data = result['data'];
        komisiDetailData.value = data;
        totalPage.value = result['data']['last_page'];
      } else {
        komisiDetailData.value = {}; // kalau gagal reset
      }
    } catch (e) {
      komisiDetailData.value = {}; // error → kosongkan data
      print("Error getRincianKomisi: $e");
    } finally {
      isLoading.value = false; // selesai loading
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
