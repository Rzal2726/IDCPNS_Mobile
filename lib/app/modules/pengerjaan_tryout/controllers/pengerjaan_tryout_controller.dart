import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

class PengerjaanTryoutController extends GetxController {
  //TODO: Implement PengerjaanTryoutController

  late final String tryoutUuid;
  final laporanController = TextEditingController();
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
  RxString timeStamp = "".obs;
  RxInt currentQuestion = 0.obs;
  RxMap<int, dynamic> selectedAnswers = <int, dynamic>{}.obs;
  RxList<Map<String, dynamic>> selectedAnswersList =
      <Map<String, dynamic>>[].obs;
  RxString uuid = "".obs;
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
    await getDetailTryout();
    await getTryoutSoal();
    if (soalList.isNotEmpty) {
      startQuestion(soalList[currentQuestion.value]['id']);
      startCountdown(tryoutData['tryout']['waktu_pengerjaan']);
    }
    uuid.value = tryoutData['uuid'];
  }

  Future<void> getDetailTryout() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/me/detail/${tryoutUuid}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        response.body['data'],
      );
      tryoutData.assignAll(data);
      print('Data Detail: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> getTryoutSoal() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/questions/${tryoutUuid}',
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response.body['data'],
      );
      soalList.assignAll(data);
      startQuestion(soalList[currentQuestion.value]['id']);
      print('Data Detail: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> sendLaporSoal({
    required int questionId,
    required String laporan,
  }) async {
    final client = Get.find<RestClientProvider>();
    final response = await client.post(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/quiz/lapor/soal',
      {"tryout_question_id": questionId.toString(), "laporan": laporan},
    );

    if (response.statusCode == 200) {
      print('Laporan: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> submitSoal() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.post(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/quiz/submit',
      {
        "tryout_transaction_id": tryoutData['uuid'],
        "instansi_id": instansiId.value,
        "jabatan_id": jabatanId,
        "items": selectedAnswersList,
      },
    );

    if (response.statusCode == 200) {
      print('Laporan: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void fetchServerTime() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/general/server-time',
    );

    if (response.statusCode == 200) {
      int timestampInMilliseconds =
          response.body['data']; // Example timestamp in milliseconds
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        timestampInMilliseconds * 1000 + (86400 * 1000),
      );
      timeStamp.value = dateTime.toString();
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void saveAnswer({
    required int questionId,
    required int optionId,
    required int waktuPengerjaan,
  }) {
    // cek index kalau sudah ada jawaban untuk questionId
    final index = selectedAnswersList.indexWhere(
      (answer) => answer['tryout_question_id'] == questionId,
    );

    final newAnswer = {
      "tryout_question_id": questionId,
      "tryout_question_option_id": optionId,
      "waktu_pengerjaan": waktuPengerjaan,
    };

    if (index != -1) {
      // replace data lama
      selectedAnswersList[index] = newAnswer;
    } else {
      // tambahin baru
      selectedAnswersList.add(newAnswer);
    }
    print("Jawaban: ${selectedAnswersList}");
  }

  void startQuestion(int questionId) {
    // simpan waktu lama sebelum pindah soal
    if (activeQuestionId != null && startTime != null) {
      final diff = DateTime.now().difference(startTime!).inSeconds;
      waktuSoal[activeQuestionId!] = (waktuSoal[activeQuestionId!] ?? 0) + diff;
    }

    // update soal aktif
    activeQuestionId = questionId;
    startTime = DateTime.now();
  }

  int getWaktuSoal(int questionId) {
    return waktuSoal[questionId] ?? 0;
  }

  void startCountdown(int minutes) {
    totalSeconds = minutes * 60;
    remainingSeconds.value = totalSeconds;

    _timer?.cancel(); // reset timer kalau ada yg jalan

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
        // TODO: aksi kalau waktu habis
        print("Waktu habis!");
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
}
