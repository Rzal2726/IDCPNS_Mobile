import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/modules/tryout_saya/controllers/tryout_saya_controller.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailTryoutSayaController extends GetxController {
  //TODO: Implement DetailTryoutSayaController
  final restClient = RestClient();
  late String lateUuid;
  late dynamic localStorage;
  final count = 0.obs;
  RxMap<String, dynamic> tryOutSaya = <String, dynamic>{}.obs;
  RxMap<String, dynamic> nilaiChart = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> listJabatan = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listInstansi = <Map<String, dynamic>>[].obs;
  RxString uuid = "".obs;
  RxString nilaiBenar = "0".obs;
  RxString totalSoal = "0".obs;
  RxString selectedJabatan = "".obs;
  RxString selectedInstansi = "".obs;

  final List<ChartData> chartData = [];
  @override
  void onInit() async {
    super.onInit();
    await initTryoutSaya();
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
    localStorage = await SharedPreferences.getInstance();
    lateUuid = await Get.arguments as String;

    await getDetailTryout();
    await getNilai();
    // await getStatsNilai();
    await getServerTime();
    await getInstansi();
    await getJabatan();
  }

  Future<void> getDetailTryout() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutSaya + lateUuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryOutSaya.assignAll(data);
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
    final response = await restClient.getData(
      url: baseUrl + apiGetNilaiDetail + lateUuid,
    );
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
    listInstansi.assignAll(data);
    selectedInstansi.value = data[0]['id'].toString();
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
    listJabatan.assignAll(data);
    selectedJabatan.value = data[0]['id'].toString();
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

  void checkList() {
    print("listJabatan: ${listJabatan}");
    print("listInstansi: ${listInstansi}");
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
