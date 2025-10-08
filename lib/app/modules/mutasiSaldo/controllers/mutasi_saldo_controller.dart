import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class MutasiSaldoController extends GetxController {
  final _restClient = RestClient();
  RxMap mutasiSaldoData = {}.obs;
  final TextEditingController searchController = TextEditingController();
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 0.obs;
  RxInt totalPage = 0.obs;
  @override
  void onInit() {
    refresh();
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

  Future<void> refresh() async {
    searchController.clear();
    await getMutasiSaldo();
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPage.value) {
      currentPage.value = page;
      getMutasiSaldo(page: currentPage.value, search: searchController.text);
      // panggil API fetch data di sini jika perlu
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      getMutasiSaldo(page: currentPage.value, search: searchController.text);
      // panggil API fetch data di sini
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      getMutasiSaldo(page: currentPage.value, search: searchController.text);
      // panggil API fetch data di sini
    }
  }

  Future<void> getMutasiSaldo({int? page, int? perpage, String? search}) async {
    try {
      isLoading.value = true;
      final url = await baseUrl + apiGetMutasiSaldo;
      var payload = {"page": page ?? 0, "perpage": 10, "search": search ?? " "};
      final result = await _restClient.postData(url: url, payload: payload);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        var data = result['data'];
        mutasiSaldoData.value = data;
        totalPage.value = result['data']['last_page'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
