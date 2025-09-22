import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:flutter/material.dart';

class PembahasanTryoutHarianController extends GetxController {
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
      url: baseUrl + apiGetTryoutHarianDetail + uuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryoutData.assignAll(data);
  }

  Future<void> getPembahasan() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetTryoutHarianPembahasan + uuid,
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
      "lathar_soal_id": questionId.toString(),
      "laporan": laporan,
    };
    final response = await restClient.postData(
      url: baseUrl + apiGetTryoutHarianLaporSoal,
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

  bool isCorrectAnswered(Map<String, dynamic> soal) {
    final List<dynamic> options = soal['options'] ?? [];
    final List<dynamic> quizDone = soal['quiz_done'] ?? [];

    if (options.isEmpty || quizDone.isEmpty) return false;

    // Cari UUID / ID jawaban yang benar
    final correctOption = options.firstWhere(
      (opt) => opt['iscorrect'] == 1,
      orElse: () => null,
    );

    if (correctOption == null) return false;

    final correctId = correctOption['id'];

    // Cek apakah user memilih jawaban yang benar
    final bool isCorrect = quizDone.any((quiz) {
      return quiz['lathar_soal_option_id'] == correctId;
    });

    return isCorrect;
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
