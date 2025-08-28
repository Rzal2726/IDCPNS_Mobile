import 'package:get/get.dart';

class BimbelController extends GetxController {
  var selectedUuid = ''.obs;
  var searchQuery = ''.obs;
  var paketList =
      [
        {
          'uuid': '1',
          'image': 'https://placehold.co/600x400/png',
          'title': 'Bimbel SKD CPNS 2024 Batch 12',
          'hargaFull': 'Rp. 348.000',
          'hargaDiskon': 'Rp.199.000 - Rp.289.000',
          'kategori': 'CPNS',
        },
        {
          'uuid': '2',
          'image': 'https://placehold.co/600x400/png',
          'title': 'Bimbel SKD CPNS 2025 Batch 16',
          'hargaFull': 'Rp. 348.000',
          'hargaDiskon': 'Rp.199.000 - Rp.289.000',
          'kategori': 'CPNS',
        },
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

  void searchPaket(String query) {
    searchQuery.value = query;
    // Dummy: hanya update query, belum filter real.
  }
}
