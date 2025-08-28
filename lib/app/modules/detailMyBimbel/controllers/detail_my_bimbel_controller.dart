import 'package:get/get.dart';

class DetailMyBimbelController extends GetxController {
  var paketName = "Bimbel SKD CPNS 2024 Batch 12".obs;
  var paketType = "Reguler".obs;
  var masaAktif = 178.obs; // hari aktif
  var platinumZone = true.obs;

  var jadwalKelas = <Map<String, String>>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    jadwalKelas.value = [
      {
        "judul": "Pertemuan 1 - TWK",
        "hari": "Rabu",
        "tanggal": "27 Agustus 2025",
        "jam": "19:30 WIB",
      },
      {
        "judul": "Pertemuan 2 - TKP",
        "hari": "Senin",
        "tanggal": "13 Januari 2025",
        "jam": "19:30 WIB",
      },
      {
        "judul": "Pertemuan 3 - TKP",
        "hari": "Selasa",
        "tanggal": "14 Januari 2025",
        "jam": "19:30 WIB",
      },
      {
        "judul": "Pertemuan 4 - TIU",
        "hari": "Rabu",
        "tanggal": "15 Januari 2025",
        "jam": "19:30 WIB",
      },
    ];
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

  void increment() => count.value++;
}
