import 'dart:async';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class PaymentCheckoutController extends GetxController {
  final _restClient = RestClient();
  var uuid = Get.arguments;
  Timer? _paymentTimer;
  RxList<String> option = ["ATM", "MBanking"].obs;
  RxString selectedOption = "ATM".obs;
  RxString timeStamp = "".obs;
  RxBool isDeveloper = false.obs;
  RxMap transactionData = {}.obs;
  RxMap paymentDetails = {}.obs;
  var selectedTab = "ATM".obs;

  @override
  void onInit() {
    checkMaintenance();
    fetchDetailPayment();
    fetchServerTime();
    startFetchingDetailPayment();
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

  void startFetchingDetailPayment() {
    // Hentikan timer lama jika ada
    _paymentTimer?.cancel();

    // Jalankan timer periodic setiap 5 detik
    _paymentTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchDetailPayment();
      fetchServerTime();
    });
  }

  void simulatePayment() async {
    final payload = {"payment_id": paymentDetails['payment_id']};
    final response = await _restClient.postData(
      url: baseUrl + apiEnhaSimulateTransaction,
      payload: payload,
    );

    print('Data: ${response}');
    Get.offNamed("/pembayaran-berhasil");
  }

  void fetchServerTime() async {
    final response = await _restClient.getData(url: baseUrl + apiGetServerTime);

    int timestampInMilliseconds =
        response['data']; // timestamp dari server (dalam detik)

    // Konversi ke DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestampInMilliseconds * 1000,
    );

    // Simpan hasil ke observable
    timeStamp.value = dateTime.toString();
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

  void cekStatus() {}

  void fetchDetailPayment() async {
    // Ambil data transaksi dari controller sebelumnya
    final response = await _restClient.getData(
      url: baseUrl + apiGetPaymentDetail + "/" + uuid,
    );

    // Ambil data dari response, pakai Map aja
    var data = Map.from(response['data']);

    // Cek level user
    if (data['user']['level']['id'] == 3) {
      isDeveloper.value = true;
    }

    // Assign data ke observable
    paymentDetails.assignAll(data);

    // Logika pembayaran
    if (paymentDetails.isNotEmpty) {
      if (paymentDetails['tanggal_paid'] == null) {
        print("Belum Dibayar");
        if (compareTimeStamp(paymentDetails['tanggal_kadaluarsa'])) {
          Get.offAllNamed(Routes.BIMBEL);
        }
      } else {
        Get.offNamed(Routes.PEMBAYARAN_BERHASIL);
        print("Sudah Dibayar");
      }
    }
  }

  bool compareTimeStamp(String fixedDateString) {
    // Convert string ke DateTime
    DateTime fixedDate = DateTime.parse(fixedDateString);

    // Convert timeStamp.value (string) ke DateTime
    DateTime currentDate = DateTime.parse(timeStamp.value);

    // Bandingkan
    print("kadaluarsa: ${fixedDate}");
    print("timeStamp: ${currentDate}");
    return currentDate.isAfter(fixedDate); // true jika currentDate > fixedDate
  }

  List<String> get instruksiAktif {
    return selectedTab.value == "ATM" ? instruksiATM : instruksiMbanking;
  }

  Future<void> checkMaintenance() async {
    final response = await _restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
