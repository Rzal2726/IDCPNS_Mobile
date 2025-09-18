import 'dart:async';

import 'package:get/get.dart';

import 'package:flutter/material.dart';


import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengerjaanTryoutHarianController extends GetxController {
  late final String tryoutUuid;
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
  RxMap<String, dynamic> tryoutData = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> soalList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> markedList = <Map<String, dynamic>>[].obs;
  RxString timeStamp = "".obs;
  RxInt currentQuestion = 0.obs;
  RxMap<int, dynamic> selectedAnswers = <int, dynamic>{}.obs;
  RxList<Map<String, dynamic>> selectedAnswersList =
      <Map<String, dynamic>>[].obs;
  RxString uuid = "".obs;
  RxInt totalSoal = 0.obs;
  DateTime initialTimer = DateTime.now();
  final count = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    tryoutUuid = await Get.arguments;
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
    localStorage = await SharedPreferences.getInstance();
    await getDetailTryout();
    await getTryoutSoal();
    if (soalList.isNotEmpty) {
      startQuestion(soalList[currentQuestion.value]['id']);
      startCountdown(tryoutData['waktu_pengerjaan']);
    }
    uuid.value = tryoutData['uuid'];
    print("Target Instansi: ${localStorage.getString('instansi')}");
    print("Target Jabatan: ${localStorage.getString('jabatan')}");
  }

  Future<void> getDetailTryout() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetTryoutHarianDetail + tryoutUuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryoutData.assignAll(data);
  }

  Future<void> getTryoutSoal() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetTryoutHarianSoal + tryoutUuid,
    );

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    soalList.assignAll(data);
    totalSoal.value = data.length;
    startQuestion(soalList[currentQuestion.value]['id']);
    for (var i in data) {
      selectedAnswersList.add({
        "lathar_soal_id": i['id'],
        "lathar_soal_option_id": 0,
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
        "Berhasil Mengirimkan Laporan",
        backgroundColor: Colors.teal,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Gagal",
        "Gagal Mengirimkan Laporan",
        backgroundColor: Colors.pink,
        colorText: Colors.white,
      );
    }
  }

  Future<void> submitSoal() async {
    try {
      final payload = {
        "lathar_id": tryoutData['uuid'],
        "items": selectedAnswersList,
      };
      print(payload);
      final response = await restClient.postData(
        url: baseUrl + apiGetTryoutHarianSubmit,
        payload: payload,
      );
      stop();
      Get.offAllNamed("/hasil-tryout-harian", arguments: uuid.value);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Tidak dapat mengirim jawaban",
        colorText: Colors.white,
        backgroundColor: Colors.pink,
      );
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
    final index = selectedAnswersList.indexWhere(
      (answer) => answer['lathar_id'] == questionId,
    );

    final diff = DateTime.now().difference(initialTimer).inSeconds;
    if (index >= 0) {
      // Ambil waktu lama lalu tambahkan waktu baru
      final previousTime = selectedAnswersList[index]['waktu_pengerjaan'] ?? 0;
      selectedAnswersList[index] = {
        "lathar_soal_id": questionId,
        "lathar_soal_option_id": optionId,
        "waktu_pengerjaan": previousTime + diff,
      };
    } else {
      // Jika belum ada → tambahkan data baru
      selectedAnswersList.add({
        "lathar_soal_id": questionId,
        "lathar_soal_option_id": optionId,
        "waktu_pengerjaan": waktuPengerjaan,
      });
    }
    initialTimer = DateTime.now();

    print("Jawaban terbaru: $selectedAnswersList");
    print("durasi: ${diff}");
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
          element['lathar_soal_id'] == id &&
          element['lathar_soal_option_id'] != 0,
    );
  }
}
