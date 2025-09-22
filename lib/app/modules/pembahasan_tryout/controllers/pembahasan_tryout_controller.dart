import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class PembahasanTryoutController extends GetxController {
  //TODO: Implement PembahasanTryoutController
  late String uuid;
  final restClient = RestClient();
  final laporanController = TextEditingController();
  RxMap<String, dynamic> tryoutData = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> listPembahasan = <Map<String, dynamic>>[].obs;
  RxInt currentNumber = 0.obs;
  @override
  void onInit() {
    super.onInit();
    initPembahasan();
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

  Future<void> initPembahasan() async {
    uuid = await Get.arguments;
    getDetailTryout();
    getPembahasan();
  }

  Future<void> getDetailTryout() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutSaya + uuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryoutData.assignAll(data);
  }

  Future<void> getPembahasan() async {
    final response = await restClient.getData(
      url: baseUrl + apiTryoutPembahasan + uuid,
    );

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listPembahasan.assignAll(data);
  }

  Future<void> sendLaporSoal({
    required int questionId,
    required String laporan,
    required BuildContext context,
  }) async {
    final payload = {
      "tryout_question_id": questionId.toString(),
      "laporan": laporan,
    };
    final response = await restClient.postData(
      url: baseUrl + apiLaporSoal,
      payload: payload,
    );

    if (response["status"] == "success") {
      laporanController.text = "";
      Get.snackbar(
        "Berhasil",
        "Berhasil mengirimkan laporan!",
        backgroundColor: Colors.teal,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Gagal",
        "Gagal mengirimkan laporan!",
        backgroundColor: Colors.pink,
        colorText: Colors.white,
      );
    }
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
