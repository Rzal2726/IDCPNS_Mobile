import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PretestRankingController extends GetxController {
  final TextEditingController searchCtrl = TextEditingController();
  var currentPage = 1.obs;
  var totalPages = 5.obs; // misal 5 halaman
  var peserta = <Map<String, dynamic>>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    fetchPeserta();
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

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchPeserta();
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchPeserta();
    }
  }

  void goToPage(int page) {
    currentPage.value = page;
    fetchPeserta();
  }
}
