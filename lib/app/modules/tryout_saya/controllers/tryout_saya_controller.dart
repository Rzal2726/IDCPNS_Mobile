import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

class TryoutSayaController extends GetxController {
  //TODO: Implement TryoutSayaController
  RxMap<String, Color> categoryColors =
      <String, Color>{"Premium": Colors.orange, "Gratis": Colors.teal}.obs;
  RxMap<String, Color> statusColors =
      <String, Color>{
        "Belum Dikerjakan": Colors.grey,
        "Sedang Dikerjakan": Colors.green,
      }.obs;
  RxList<String> options = ["Semua", "CPNS", "BUMN", "Kedinasan", "PPPK"].obs;
  RxList<String> optionsPengerjaan =
      ["Semua", "Belum Dikerjakan", "Sedang Dikerjakan"].obs;
  RxList<String> optionsHasil = ["Semua", "Tidak Lulus", "Lulus"].obs;
  RxList<Map<dynamic, dynamic>> listData =
      <Map<dynamic, dynamic>>[
        {"kategori": "Gratis", "status": "Sedang Dikerjakan"},
        {"kategori": "Gratis", "status": "Sedang Dikerjakan"},
        {"kategori": "Gratis", "status": "Sedang Dikerjakan"},
        {"kategori": "Premium", "status": "Sedang Dikerjakan"},
      ].obs;
  RxString selectedPaketKategori = "Semua".obs;
  RxString selectedPengerjaan = "Semua".obs;
  RxString selectedHasil = "Semua".obs;
  final count = 0.obs;
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

  void fetchTryoutSaya() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/tryout/me/list',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void fetchKategori() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/tryout/menu/category',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }
}
