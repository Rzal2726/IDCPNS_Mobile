import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengerjaanTryoutController extends GetxController {
  late final String tryoutUuid;
  late SharedPreferences localStorage;
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
    uuid.value = await tryoutData['uuid'];
    if (soalList.isNotEmpty) {
      startQuestion(soalList[currentQuestion.value]['id']);
      startCountdown(tryoutData['tryout']['waktu_pengerjaan']);
    }

    if (localStorage.getString("soal_uuid") == uuid.value) {
      final prevJawaban = jsonDecode(
        localStorage.getString("selected_answer_list")!,
      );
      final prevAnswers = jsonDecode(
        localStorage.getString("selected_answer")!,
      );

      // Convert List<dynamic> → List<Map<String, dynamic>>
      final parsedList =
          (prevJawaban as List)
              .map((item) => Map<String, dynamic>.from(item))
              .toList();

      // Assign ke RxList supaya reaktif
      selectedAnswersList.assignAll(parsedList);

      // Convert Map<String, dynamic> → RxMap<int, dynamic>
      selectedAnswers.assignAll(
        (prevAnswers as Map<String, dynamic>).map(
          (key, value) => MapEntry(int.parse(key), value),
        ),
      );
    }

    localStorage.setString("soal_uuid", uuid.value);
    print("Target Instansi: ${localStorage.getString('instansi')}");
    print("Target Jabatan: ${localStorage.getString('jabatan')}");
  }

  Future<void> getDetailTryout() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutSaya + tryoutUuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryoutData.assignAll(data);
  }

  Future<void> getTryoutSoal() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetQuestions + tryoutUuid,
    );

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    soalList.assignAll(data);
    totalSoal.value = response['total'];
    startQuestion(soalList[currentQuestion.value]['id']);
    for (var i in data) {
      selectedAnswersList.add({
        "tryout_question_id": i['id'],
        "tryout_question_option_id": 0,
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
        "tryout_transaction_id": tryoutData['uuid'],
        "instansi_id": localStorage.getString('instansi'),
        "jabatan_id": localStorage.getString('jabatan'),
        "items": selectedAnswersList,
      };
      print(payload);
      final response = await restClient.postData(
        url: baseUrl + apiSubmitSoal,
        payload: payload,
      );
      stop();
      localStorage.remove("selected_answer_list");
      localStorage.remove("selected_answer");
      localStorage.remove("soal_uuid");
      localStorage.remove("sisa_durasi");
      Get.offAllNamed("/hasil-tryout", arguments: uuid.value);
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
      (answer) => answer['tryout_question_id'] == questionId,
    );

    final diff = DateTime.now().difference(initialTimer).inSeconds;
    if (index >= 0) {
      // Ambil waktu lama lalu tambahkan waktu baru
      final previousTime = selectedAnswersList[index]['waktu_pengerjaan'] ?? 0;
      selectedAnswersList[index] = {
        "tryout_question_id": questionId,
        "tryout_question_option_id": optionId,
        "waktu_pengerjaan": previousTime + diff,
      };
    } else {
      // Jika belum ada → tambahkan data baru
      selectedAnswersList.add({
        "tryout_question_id": questionId,
        "tryout_question_option_id": optionId,
        "waktu_pengerjaan": waktuPengerjaan,
      });
    }
    initialTimer = DateTime.now();

    print("selectedAnswers: ${selectedAnswers}");
    print("selectedAnswers2: ${localStorage.getString("selected_answer")}");
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
    print("Sisa Sebelumnya: ${localStorage.getInt("sisa_durasi").toString()}");
    totalSeconds = minutes * 60;
    remainingSeconds.value = totalSeconds;

    // Jika ada data lama, pakai sisa waktu dari localStorage
    if (localStorage.getString("soal_uuid") == uuid.value) {
      remainingSeconds.value =
          localStorage.getInt("sisa_durasi") ?? totalSeconds;
    }

    _timer?.cancel(); // reset timer kalau ada yg jalan

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;

        // Simpan sisa durasi setiap detik
        localStorage.setInt("sisa_durasi", remainingSeconds.value);
      } else {
        // Hentikan timer
        timer.cancel();

        // Pastikan waktu tidak negatif
        remainingSeconds.value = 0;

        // Hapus sisa durasi dari localStorage (opsional)
        localStorage.remove("sisa_durasi");

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
          element['tryout_question_id'] == id &&
          element['tryout_question_option_id'] != 0,
    );
  }
}
