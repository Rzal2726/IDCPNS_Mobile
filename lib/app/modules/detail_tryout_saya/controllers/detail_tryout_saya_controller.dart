import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/modules/tryout_saya/controllers/tryout_saya_controller.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chart_data_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailTryoutSayaController extends GetxController {
  //TODO: Implement DetailTryoutSayaController
  final restClient = RestClient();
  late String lateUuid;
  late dynamic localStorage;
  final count = 0.obs;
  RxMap<String, dynamic> loading = <String, dynamic>{}.obs;

  RxMap<String, dynamic> tryOutSaya = <String, dynamic>{}.obs;
  RxMap<String, dynamic> nilaiChart = <String, dynamic>{}.obs;
  RxMap<String, dynamic> nilaiChartStat = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> listJabatan =
      <Map<String, dynamic>>[
        {"id": 0, "uuid": "", "nama": "Pilih Jabatan", "menu_category_id": 0},
      ].obs;
  RxList<Map<String, dynamic>> listInstansi =
      <Map<String, dynamic>>[
        {"id": 0, "uuid": "", "nama": "Pilih Instansi", "menu_category_id": 0},
      ].obs;
  RxString uuid = "".obs;
  RxString nilaiBenar = "0".obs;
  RxString totalSoal = "0".obs;
  RxString selectedJabatan = "0".obs;
  RxString selectedInstansi = "0".obs;
  RxInt totalValue = 0.obs;

  final RxList<ChartData> chartData = <ChartData>[].obs;
  List<ChartData>? get chartDataList => chartData;

  @override
  void onInit() async {
    await initializeDateFormatting('id_ID', null);
    super.onInit();
    await initTryoutSaya();
    checkMaintenance();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initTryoutSaya() async {
    loading['chart'] = true;
    localStorage = await SharedPreferences.getInstance();
    lateUuid = await Get.arguments as String;

    await getDetailTryout();
    await getNilai();
    await getServerTime();
    await getInstansi();
    await getJabatan();
    await getStatsNilai();
    loading['chart'] = false;
  }

  Future<void> getDetailTryout() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutSaya + lateUuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryOutSaya.assignAll(data);
    print(data);
    print("tanggal sekarang ${DateTime.now()}");
  }

  Future<void> getNilai() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetNilaiSaya + lateUuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    nilaiChart.assignAll(data);
  }

  Future<void> getStatsNilai() async {
    try {
      final response = await restClient.getData(
        url: baseUrl + apiGetNilaiDetail + lateUuid,
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(
        response['data'],
      );
      print("chart nilai: ${data}");

      // Simpan semua data untuk digunakan di widget
      nilaiChartStat.assignAll(data);

      // Bersihkan data lama
      chartData.clear();

      // Ambil statistik untuk subcategories agar masuk ke Bar Chart
      if (data['statistics'] != null) {
        for (var stat in data['statistics']) {
          String label = stat['label']; // TWK, TIU, TKP

          for (var soal in stat['waktu_pengerjaan']) {
            final title = soal['title'] ?? '';
            final noSoal = soal['no_soal'] ?? 0;
            final value = soal['value'] ?? 0;

            // Misal value 1 = benar, 0 = salah/kosong
            Color color;
            String status;
            if (value == 1) {
              color = Colors.green;
              status = 'Benar';
            } else {
              color = Colors.red;
              status = 'Salah';
            }

            chartData.add(
              ChartData('Soal $noSoal', value.toString(), Colors.amberAccent),
            );
          }
        }
      }

      for (var stat in nilaiChartStat['statistics']) {
        for (var waktu in stat['waktu_pengerjaan']) {
          totalValue.value += waktu['value'] as int;
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> getServerTime() async {
    final response = await restClient.getData(url: baseUrl + apiGetServerTime);
  }

  Future<void> getInstansi() async {
    final response = await restClient.getData(
      url:
          baseUrl +
          apiGetInstansi +
          tryOutSaya['tryout']['menu_category_id'].toString(),
    );

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listInstansi.addAll(data);
  }

  Future<void> getJabatan() async {
    final response = await restClient.getData(
      url:
          baseUrl +
          apiGetJabatan +
          tryOutSaya['tryout']['menu_category_id'].toString(),
    );

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listJabatan.addAll(data);
  }

  Future<void> resetTryout() async {
    final payload = {"tryout_transaction_id": lateUuid};

    final response = await restClient.postData(
      url: baseUrl + apiResetTryout,
      payload: payload,
    );

    await getDetailTryout();
  }

  String hitungMasaAktif(String tanggal) {
    String expiredDate = tanggal;

    // parse string ke DateTime
    DateTime target = DateTime.parse(expiredDate);
    DateTime now = DateTime.now();

    // hitung difference
    Duration diff = target.difference(now);
    return diff.inDays.toString();
  }

  int hitungTotalMasaAktif(String tanggalBeli, String tanggalKadaluarsa) {
    String expiredDate = tanggalKadaluarsa;
    String buyDate = tanggalBeli;

    // parse string ke DateTime
    DateTime target = DateTime.parse(expiredDate);
    DateTime targetBuy = DateTime.parse(buyDate);

    // hitung difference
    Duration diff = target.difference(targetBuy);
    return diff.inDays;
  }

  void checkList() {
    print("listJabatan: ${listJabatan}");
    print("listInstansi: ${listInstansi}");
  }

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }

  String formatTanggal(String? tanggalStr) {
    if (tanggalStr == null || tanggalStr.isEmpty) return "-";
    try {
      DateTime date = DateTime.parse(tanggalStr);
      return DateFormat("dd MMMM yyyy", "id_ID").format(date);
    } catch (e) {
      return tanggalStr; // fallback kalau gagal parse
    }
  }
}

class LineChartData {
  LineChartData(this.x, this.y, this.color);

  final String x;
  final String y;
  final Color color;
}
