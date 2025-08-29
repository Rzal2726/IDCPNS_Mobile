import 'package:get/get.dart';

class PaymentCheckoutController extends GetxController {
  //TODO: Implement PaymentCheckoutController

  var countdown = "23:59:55".obs;
  var bank = "BANK BRI".obs;
  var vaNumber = "262159999402839".obs;
  var namaAkun = "IDC PNS INDONESIA".obs;
  var totalHarga = 203440.obs;

  var selectedTab = "ATM".obs;

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

  final instruksiATM = [
    "Masukkan kartu, pilih bahasa, lalu masukkan PIN Anda",
    "Pilih \"Menu Lainnya\" dan pilih \"Transfer\"",
    "Pilih ke \"Rekening Bank Lain\"",
    "Masukkan nomor Virtual Account lalu pilih \"Benar\"",
    "Masukkan jumlah transfer sesuai tagihan",
    "Ikuti instruksi hingga transaksi selesai",
  ];

  // Data untuk Mbanking
  final instruksiMbanking = [
    "Login ke aplikasi BRI Mobile Banking",
    "Pilih menu \"Pembayaran\"",
    "Pilih menu \"BRIVA\"",
    "Masukkan nomor Virtual Account",
    "Masukkan jumlah sesuai tagihan",
    "Konfirmasi transaksi hingga selesai",
  ];

  void cekStatus() {
    Get.snackbar("Pembayaran", "Cek status pembayaran (dummy)");
  }

  List<String> get instruksiAktif {
    return selectedTab.value == "ATM" ? instruksiATM : instruksiMbanking;
  }
}
