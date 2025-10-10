import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
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
    refresh();
    super.onInit();
  }

  Future<void> getMutasi() async {
    try {
      final url = baseUrl + apiGetRekeningUser;
      final result = await _restClient.getData(url: url);

      if (result["status"] == "success") {
        bankList.value = result['data'];
      } else {
        notifHelper.show(
          result["messages"] ?? "Gagal memuat data bank",
          type: 0,
        );
      }
    } catch (e) {
      notifHelper.show("Error memuat data bank: $e", type: 0);
    }
  }

  Future<void> refresh() async {
    nominalController.clear();
    rekeningNum.value = "";
    nominalValue.value = 0;
    rekeningId.value = 0;
    await getMutasi();
    nominalController.addListener(() {
      final text = nominalController.text.replaceAll('.', '');
      if (text.isEmpty) {
        nominalValue.value = 0;
        return;
      }

      final number = int.tryParse(text);
      if (number == null) return;

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

  Future<void> postMutasi() async {
    try {
      final url = baseUrl + apiPostMutasiSaldo;
      var payload = {
        "nominal": int.parse(nominalController.text.replaceAll('.', '')),
        "rekening": rekeningId.value,
      };
      print("xxx $payload");

      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {
        notifHelper.show("Penarikan berhasil diproses", type: 1);
      } else {
        notifHelper.show(result["messages"] ?? "Terjadi kesalahan", type: 0);
      }
    } catch (e) {
      notifHelper.show(
        "Komisi yang tersedia tidak cukup untuk melakukan penarikan ini",
        type: 0,
      );
    }
  }
}
