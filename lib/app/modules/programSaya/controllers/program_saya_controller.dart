import 'package:get/get.dart';

class ProgramSayaController extends GetxController {
  RxInt currentPage = 1.obs;
  RxInt totalPages = 10.obs; // total halaman (bisa diatur sesuai data API)
  RxInt selectedTab = 0.obs;
  RxString searchQuery = ''.obs;

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

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

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
}
