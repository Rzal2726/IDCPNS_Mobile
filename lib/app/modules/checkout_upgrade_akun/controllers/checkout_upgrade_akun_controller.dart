import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutUpgradeAkunController extends GetxController {
  //TODO: Implement TryoutCheckoutController
  final restClient = RestClient();
  late Map<String, dynamic> transaction;
  Timer? _paymentTimer;
  RxMap<String, dynamic> transactionData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> paymentDetails = <String, dynamic>{}.obs;
  RxList<String> option = ["ATM", "MBanking"].obs;
  RxString selectedOption = "ATM".obs;
  RxString timeStamp = "".obs;
  RxBool isDeveloper = false.obs;
  RxBool isRedirected = false.obs;
  RxBool isSuccess = false.obs;
  RxBool isInit = false.obs;
  DateTime? initialTime;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    initPayment();
    fetchServerTime();
    startFetchingDetailPayment();
    checkMaintenance();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    stopFetchingDetailPayment();
  }

  Future<void> initPayment() async {
    transaction = await Get.arguments;
    fetchDetailPayment();
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

  void stopFetchingDetailPayment() {
    _paymentTimer?.cancel();
    _paymentTimer = null;
  }

  void fetchDetailPayment() async {
    // transactionData.assignAll(prevController.transactionData);
    final response = await restClient.getData(
      url: baseUrl + apiGetPaymentDetail + "/" + transaction['payment_id'],
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    if (data['user']['level']['id'] == 3) {
      isDeveloper.value = true;
    }
    paymentDetails.assignAll(data);
    if (paymentDetails.isNotEmpty) {
      if (paymentDetails['tanggal_paid'] == null) {
        print("Belum Dibayar");
        if (isInit.value == true) {
          final pref = await SharedPreferences.getInstance();
          DateTime? isOvo;
          if (paymentDetails['payment_details'][0]['xendit_payment_method_id'] ==
              10) {
            isOvo = DateTime.parse(
              pref.getString("initTime")!,
            ).add(Duration(minutes: 1));
          } else {
            isOvo = DateTime.parse(
              pref.getString("initTime")!,
            ).add(Duration(days: 1));
          }
          if (paymentDetails[''])
            if (DateTime.now().isAfter(isOvo)) {
              Get.offNamed("/checkout-gagal");
            }
        }
        if (isRedirected.value == false) {
          if (data['invoice_url'] != null) {
            final Uri url = Uri.parse(data['invoice_url']);
            if (await canLaunchUrl(url)) {
              await launchUrl(
                url,
                mode: LaunchMode.externalApplication, // Buka di browser
              );
            } else {
              print("Tidak bisa membuka URL: $url");
            }
            isRedirected.value = true;
          } else {
            print("No Url");
          }
        }
        if (compareTimeStamp(paymentDetails['tanggal_kadaluarsa'])) {
          Get.offAllNamed("/tryout");
        }
      } else {
        Get.offNamed("/pembayaran-berhasil");
        print("Sudah Dibayar");
      }
    }
  }

  void fetchServerTime() async {
    final response = await restClient.getData(url: baseUrl + apiGetServerTime);

    int timestampInMilliseconds =
        response['data']; // timestamp dari server (dalam detik)

    // Konversi ke DateTime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestampInMilliseconds * 1000,
    );
    if (isInit.value == false) {
      initialTime = DateTime.fromMillisecondsSinceEpoch(
        timestampInMilliseconds * 1000,
      );
      isInit.value = true;
      final preferences = await SharedPreferences.getInstance();
      preferences.setString("initTime", initialTime.toString());
    }

    // Simpan hasil ke observable
    timeStamp.value = dateTime.toString();
  }

  void simulatePayment() async {
    final payload = {"payment_id": paymentDetails['payment_id']};
    final response = await restClient.postData(
      url: baseUrl + apiEnhaSimulateTransaction,
      payload: payload,
    );

    print('Data: ${response}');
    Get.offNamed("/pembayaran-berhasil");
  }

  String formatCurrency(dynamic number) {
    var customFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp.',
      decimalDigits: 0,
    );

    // ambil hanya digit, titik, koma
    final clean = number.toString().replaceAll(RegExp(r'[^0-9.,]'), "");

    // ganti koma dengan titik biar konsisten
    final normalized = clean.replaceAll(",", ".");

    final parsed = double.tryParse(normalized) ?? 0;

    return customFormatter.format(parsed);
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

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
