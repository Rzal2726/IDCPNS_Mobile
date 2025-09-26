import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class PretestController extends GetxController {
  var bimbelUuid = Get.arguments['uuid'];
  var uuid = Get.arguments['uuidParent'];
  late dynamic localStorage;
  final laporanController = TextEditingController();
  final restClient = RestClient();
  // total waktu dalam detik
  late int totalSeconds;

  // reactive sisa waktu
  RxInt remainingSeconds = 0.obs;

  Timer? _timer;
  Map<int, int> waktuSoal = {}; // key = questionId, value = detik

  DateTime? startTime;
  int? activeQuestionId;

  RxInt numberPerPage = 3.obs;
  RxInt? numberLength;
  RxInt currentPage = 0.obs;
  RxInt jabatanId = 1.obs;
  RxInt instansiId = 1.obs;
  RxMap<String, dynamic> bimbelData = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> soalList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> markedList = <Map<String, dynamic>>[].obs;
  RxString timeStamp = "".obs;
  RxInt currentQuestion = 0.obs;
  RxMap<int, dynamic> selectedAnswers = <int, dynamic>{}.obs;
  RxList<Map<String, dynamic>> selectedAnswersList =
      <Map<String, dynamic>>[].obs;
  RxInt totalSoal = 0.obs;
  final count = 0.obs;

  @override
  void onInit() async {
    super.onInit();

    await initPengerjaan();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _timer?.cancel();
    laporanController.dispose();
  }

  Future<void> initPengerjaan() async {
    await getDetailBimbel();
    await getBimbelSoal();
    if (soalList.isNotEmpty) {
      startQuestion(soalList[currentQuestion.value]['id']);
      final events = bimbelData['bimbel']['events'] as List;
      final event = events.firstWhere(
        (e) => e['uuid'] == bimbelUuid,
        orElse: () => null,
      );

      if (event != null) {
        startCountdown(event['waktu_pengerjaan']);
      }
    }
    uuid.value = bimbelData['uuid'];
  }

  Future<void> getDetailBimbel() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailBimbelSaya + "/" + uuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    bimbelData.assignAll(data);
  }

  Future<void> getBimbelSoal() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetPretestQuestions + "/" + bimbelUuid,
    );

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    soalList.assignAll(data);
    totalSoal.value = data.length;
    startQuestion(soalList[currentQuestion.value]['id']);
    for (var i in data) {
      selectedAnswersList.add({
        "pretest_soal_id": i['id'],
        "pretest_soal_option_id": 0,
        "waktu_pengerjaan": 0,
      });
    }
  }

  Future<void> sendLaporSoal({
    required int questionId,
    required String laporan,
    required BuildContext context,
  }) async {
    final payload = {
      "pretest_soal_id": questionId.toString(),
      "laporan": laporan,
    };
    print("xxc ${payload.toString()}");
    final response = await restClient.postData(
      url: baseUrl + apiLaporPretestSoal,
      payload: payload,
    );

    if (response["status"] == "success") {
      laporanController.text = "";
      notifHelper.show("Berhasil Mengirimkan Laporan", type: 1);
    } else {
      notifHelper.show("Gagal Mengirimkan Laporan", type: 0);
    }
  }

  Future<void> submitSoal() async {
    try {
      final payload = {
        "bimbel_transaction_id": bimbelData['uuid'],
        "bimbel_event_id": bimbelUuid,
        "items": selectedAnswersList,
      };

      final response = await restClient.postData(
        url: baseUrl + apiSubmitPretest,
        payload: payload,
      );

      stop();

      if (response['status'] == 'success') {
        Get.offAllNamed(
          Routes.PRETEST_RESULT,
          arguments: {"uuid": uuid, "bimbelUuid": bimbelUuid},
        );
      } else {
        notifHelper.show(
          response['message'] ?? "Gagal mengirim jawaban",
          type: 0,
        );
      }
    } catch (e) {
      notifHelper.show("Tidak dapat mengirim jawaban", type: 0);
    }
  }

  void fetchServerTime() async {
    final response = await restClient.getData(url: baseUrl + apiGetServerTime);

    int timestampInMilliseconds =
        response.body['data']; // Example timestamp in milliseconds
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestampInMilliseconds * 1000 + (86400 * 1000),
    );
    timeStamp.value = dateTime.toString();
  }

  void saveAnswer({
    required int questionId,
    required int optionId,
    required int waktuPengerjaan,
  }) {
    final newAnswer = {
      "pretest_soal_id": questionId,
      "pretest_soal_option_id": optionId,
      "waktu_pengerjaan": waktuPengerjaan,
    };
    // Cek apakah jawaban untuk soal ini sudah ada
    final index = selectedAnswersList.indexWhere(
      (answer) => answer['pretest_soal_id'] == questionId,
    );
    print("xxz0 ${selectedAnswersList.toString()}");
    if (index >= 0) {
      print("xxz1 ${waktuPengerjaan.toString()}");
      // Jika sudah ada → replace data lama
      selectedAnswersList[index] = newAnswer;
    } else {
      print("xxz2 ${waktuPengerjaan.toString()}");
      // Jika belum ada → tambah data baru
      selectedAnswersList.add(newAnswer);
    }

    print("Jawaban terbaru: $selectedAnswersList");
  }

  /// Mulai soal baru, simpan waktu lama terlebih dahulu
  void startQuestion(int questionId) {
    final now = DateTime.now();

    // Jika ada soal aktif sebelumnya, simpan durasinya
    if (activeQuestionId != null && startTime != null) {
      final diff = now.difference(startTime!).inSeconds;

      // Update total waktu soal sebelumnya
      waktuSoal[activeQuestionId!] = (waktuSoal[activeQuestionId!] ?? 0) + diff;
    }

    // Update soal aktif ke soal baru
    activeQuestionId = questionId;
    startTime = now;
  }

  /// Ambil total waktu untuk soal tertentu
  int getWaktuSoal(int questionId) {
    // Jika soal ini sedang aktif, hitung waktu tambahan sementara
    if (activeQuestionId == questionId && startTime != null) {
      final diff = DateTime.now().difference(startTime!).inSeconds;
      return (waktuSoal[questionId] ?? 0) + diff;
    }

    // Jika soal tidak aktif, kembalikan waktu yang sudah tersimpan
    return waktuSoal[questionId] ?? 0;
  }

  /// Hentikan pencatatan waktu dan simpan soal terakhir
  void stop() {
    if (activeQuestionId != null && startTime != null) {
      final diff = DateTime.now().difference(startTime!).inSeconds;
      waktuSoal[activeQuestionId!] = (waktuSoal[activeQuestionId!] ?? 0) + diff;
    }
    activeQuestionId = null;
    startTime = null;
  }

  void startCountdown(int minutes) {
    totalSeconds = minutes * 60;
    remainingSeconds.value = totalSeconds;

    _timer?.cancel(); // reset timer kalau ada yg jalan

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        // Hentikan timer
        timer.cancel();

        // Pastikan waktu tidak negatif
        remainingSeconds.value = 0;

        // Stop tracking waktu soal terakhir
        stop();

        // Otomatis submit jawaban
        submitSoal();
      }
    });
  }

  String get formattedTime {
    final duration = Duration(seconds: remainingSeconds.value);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void markSoal(Map<String, dynamic> soal) {
    if (checkMark(soal)) {
      markedList.remove(soal);
    } else {
      markedList.add(soal);
    }
    print(markedList);
    print(markedList.length);
  }

  bool checkMark(Map<String, dynamic> soal) {
    return markedList.contains(soal);
  }

  bool checkAnswer(int id) {
    print(selectedAnswersList);
    return selectedAnswersList.any(
      (element) =>
          element['pretest_soal_id'] == id &&
          element['pretest_soal_option_id'] != 0,
    );
  }
}
