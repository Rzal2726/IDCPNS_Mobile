import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class ProgramSayaController extends GetxController {
  final _restClient = RestClient();
  RxList bimbelData = [].obs;
  RxList tryoutData = [].obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 10.obs; // total halaman (bisa diatur sesuai data API)
  RxInt selectedTab = 0.obs;
  RxString searchQuery = ''.obs;

  // 🔹 daftar program (sementara hardcode, nanti bisa diisi dari API)
  var programs =
      <String>[
        "TRYOUT SKD CPNS 2025 BATCH 60",
        "TRYOUT SKD CPNS 2025 BATCH 61",
        "TRYOUT PPPK 2025 BATCH 1",
        "BIMBEL INTENSIF CPNS 2025",
        "BIMBEL P3K GURU 2025",
      ].obs;

  @override
  void onInit() {
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

  // pagination
  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page;
    }
  }

  // 🔹 filter program berdasarkan search
  List<String> get filteredPrograms {
    if (searchQuery.value.isEmpty) return programs;
    return programs
        .where((p) => p.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  Future<void> getBimbel() async {
    try {
      final url = await baseUrl + apiGetBimbel;

      final result = await _restClient.getData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        bimbelData.value = result['data'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
