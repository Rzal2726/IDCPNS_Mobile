import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:intl/intl.dart';

class TarikKomisiController extends GetxController {
  final _restClient = RestClient();
  TextEditingController nominalController = TextEditingController();
  RxList bankList = [].obs;
  RxString rekeningNum = "".obs;
  RxInt nominalValue = 0.obs;
  RxInt rekeningId = 0.obs;

  final List<String> informationPoints = [
    'Minimal penarikan komisi adalah Rp.500.000',
    'Biaya Admin setiap penarikan adalah Rp.4.950',
    'Pastikan komisi yang ditarik tidak lebih dari Komisi Tersedia',
    'Penarikan komisi akan diproses 3 Hari kerja (Tergantung antrian penarikan)',
  ];

  final count = 0.obs;

  final formatter = NumberFormat.decimalPattern('id');

  @override
  void onInit() {
    super.onInit();
    getMutasi();

    nominalController.addListener(() {
      final text = nominalController.text.replaceAll('.', '');
      if (text.isEmpty) {
        nominalValue.value = 0;
        return;
      }

      final number = int.tryParse(text);
      if (number == null) return;

      // simpan ke RxInt
      nominalValue.value = number;

      final newText = formatter.format(number);
      if (nominalController.text != newText) {
        nominalController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    });
  }

  Future<void> getMutasi() async {
    try {
      final url = baseUrl + apiGetRekeningUser;
      final result = await _restClient.getData(url: url);

      if (result["status"] == "success") {
        bankList.value = result['data'];
      }
    } catch (e) {
      print("Error getBank: $e");
    }
  }

  Future<void> postMutasi() async {
    try {
      final url = baseUrl + apiPostMutasiSaldo;
      var payload = {
        "nominal": int.parse(nominalController.text.replaceAll('.', '')),
        "rekening": rekeningNum.value,
      };
      print("xxx $payload");

      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {
        Get.snackbar(
          "Berhasil",
          "Penarikan berhasil diproses",
          snackPosition: SnackPosition.TOP, // notif di atas
          margin: EdgeInsets.all(12),
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Gagal",
          result["messages"] ?? "Terjadi kesalahan",
          snackPosition: SnackPosition.TOP, // notif di atas
          margin: EdgeInsets.all(12),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Komisi yang tersedia tidak cukup untuk melakukan penarikan ini",
        snackPosition: SnackPosition.TOP, // notif di atas
        margin: EdgeInsets.all(12),
      );
    }
  }
}
