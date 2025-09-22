import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class TryoutHarianController extends GetxController {
  //TODO: Implement TryoutHarianController

  final count = 0.obs;
  final restClient = RestClient();
  DateTime today = DateTime.now();
  RxBool loading = true.obs;

  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> doneList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    initKategori();
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

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    today = selectedDay;
  }

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }

  Future<void> initKategori() async {
    loading.value = true;
    await getKategori();
    await getDoneList();
    loading.value = false;
  }

  Future<void> getKategori() async {
    final response = await restClient.getData(url: baseUrl + apiGetKategori);
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    categories.assignAll(data);
  }

  Future<void> getDoneList() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetTryoutHarianDoneList,
    );
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    doneList.assignAll(data);
  }
}
