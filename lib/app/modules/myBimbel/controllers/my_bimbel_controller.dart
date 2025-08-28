import 'package:get/get.dart';

class MyBimbelController extends GetxController {
  var searchText = ''.obs;
  var listBimbel =
      [
        {'title': 'Bimbel SKD CPNS 2024 Batch 12', 'jenis': 'Reguler'},
        {'title': 'Bimbel SKD CPNS 2025 Batch 16', 'jenis': 'Extended'},
      ].obs;

  final count = 0.obs;
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

  void doSearch() {
    Get.snackbar('Cari', 'Fitur pencarian belum tersedia');
  }
}
