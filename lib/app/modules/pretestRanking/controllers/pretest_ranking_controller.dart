import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class PretestRankingController extends GetxController {
  final box = GetStorage();
  final _restClient = RestClient();
  var uuid = Get.arguments;
  final TextEditingController searchController = TextEditingController();

  RxInt currentPage = 1.obs;
  RxInt totalPages = 0.obs;
  RxInt totalPage = 0.obs;

  var peserta = <Map<String, dynamic>>[].obs;
  RxList rankData = [].obs;
  RxInt userRank = 0.obs;

  final count = 0.obs;
  @override
  void onInit() {
    getData();
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

  void fetchPeserta() {
    // contoh dummy data
    peserta.value = List.generate(
      10,
      (index) => {
        "rank": (index + 1) + (currentPage.value - 1) * 10,
        "name": "Peserta ${(index + 1) + (currentPage.value - 1) * 10}",
        "nilai": 50 + index,
      },
    );
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

  Future<void> getData({int? page, String? search}) async {
    try {
      final url = await baseUrl + apiGetRankingBimbel + "/" + uuid.toString();
      final payload = {
        "perpage": 10,
        "search": search ?? "",
        "page": page ?? 0,
      };
      final result = await _restClient.postData(url: url, payload: payload);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        rankData.value = result['data']['data'];
        totalPage.value = result['data']['last_page'];

        final idUser = box.read('idUser');
        final user = rankData.firstWhere(
          (e) => e['user_id'] == idUser,
          orElse: () => {},
        );

        userRank.value = user.isNotEmpty ? user['rank'] : 0;
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
