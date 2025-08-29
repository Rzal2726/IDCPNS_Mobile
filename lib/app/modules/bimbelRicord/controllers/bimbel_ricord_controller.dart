import 'package:get/get.dart';

class BimbelRecordController extends GetxController {
  var isLoading = true.obs;
  var rekamanList = <Map<String, dynamic>>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    fetchRekaman();
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

  void fetchRekaman() async {
    await Future.delayed(Duration(seconds: 1)); // dummy loading
    rekamanList.value = [
      {
        "judul": "Pertemuan 1 - TWK",
        "hari": "Jum'at",
        "tanggal": "22 Agustus 2025",
        "jam": "19:30 WIB",
      },
      {
        "judul": "Pertemuan 2 - TIU",
        "hari": "Jum'at",
        "tanggal": "30 Agustus 2024",
        "jam": "19:30 WIB",
      },
      {
        "judul": "Pertemuan 3 - TKP",
        "hari": "Sabtu",
        "tanggal": "31 Agustus 2024",
        "jam": "19:30 WIB",
      },
      {
        "judul": "Pertemuan 4 - TWK",
        "hari": "Minggu",
        "tanggal": "01 September 2024",
        "jam": "19:30 WIB",
      },
    ];
    isLoading.value = false;
  }

  void tontonVideo(Map<String, dynamic> rekaman) {
    Get.snackbar("Tonton Video", "Memutar ${rekaman['judul']} (dummy)");
  }
}
