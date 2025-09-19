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
  @override
  void onInit() {
    getRincianKomisi();
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
      final url = await baseUrl + apiGetRincianKomisi;

      final result = await _restClient.postData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        var data = result['data'];
        komisiDetailData.value = data;
        totalPage.value = result['data']['last_page'];
        print("asda ${data['data'][0]['user'].toString()}");
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
