import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class PretestTourController extends GetxController {
  var currentIndex = 0.obs;
  var answers = <int, int>{}.obs; // nomor -> opsiIndex
  var flagged = <int>{}.obs;
  var bookmarked = <int>{}.obs;
  var remainingSeconds = (5 * 60).obs; // default 5 menit

  Timer? _timer;

  // Showcase keys
  final GlobalKey keyFlag = GlobalKey();
  final GlobalKey keyReport = GlobalKey();
  final GlobalKey keyQuestion = GlobalKey();
  final GlobalKey keyOptions = GlobalKey();
  final GlobalKey keyFinish = GlobalKey();
  final GlobalKey keyNumberNav = GlobalKey();
  final GlobalKey keyPrev = GlobalKey();
  final GlobalKey keyTimer = GlobalKey();
  final GlobalKey keyNext = GlobalKey();

  bool _started = false;

  // step showcase
  late List<GlobalKey> steps;
  int currentStep = 0;

  final List<Soal> soalList = [
    Soal(
      nomor: 1,
      judul: "Pertemuan 1 - TWK",
      pertanyaan:
          "Sebagai pegawai kantoran, Anda memiliki delapan jam kerja aktif. Di lain sisi, Anda adalah seorang istri dan ibu dari dua balita. Bagaimana Anda mengatur tugas Anda sebagai pegawai dan ibu rumah tangga agar semua berjalan seimbang?",
      opsi: [
        "Selalu mendahulukan pekerjaan kantor karena sudah berkomitmen pada perusahaan",
        "Mendahulukan kepentingan keluarga dibandingkan tugas kantor",
        "Membagi waktu seadil-adilnya untuk keluarga dan pekerjaan",
        "Mengerti posisinya dan mampu menyesuaikan diri di rumah maupun di kantor",
        "Melaksanakan tugas-tugas yang memang seharusnya dikerjakannya",
      ],
    ),
    Soal(
      nomor: 2,
      judul: "Pertemuan 2 - TIU",
      pertanyaan:
          "Anda diberi tanggung jawab untuk memimpin sebuah tim proyek. Namun, beberapa anggota tim tidak disiplin. Apa yang Anda lakukan?",
      opsi: [
        "Memberi teguran keras",
        "Mengabaikan karena tidak penting",
        "Memberikan contoh disiplin terlebih dahulu",
        "Melaporkan ke atasan",
        "Mencari anggota baru",
      ],
    ),
    Soal(
      nomor: 3,
      judul: "Pertemuan 3 - TKP",
      pertanyaan:
          "Saat ujian CPNS online berlangsung, tiba-tiba koneksi internet Anda terganggu. Apa yang Anda lakukan?",
      opsi: [
        "Langsung panik",
        "Mencoba menyalahkan panitia",
        "Tetap tenang dan berusaha memperbaiki koneksi",
        "Keluar ruangan",
        "Menunggu tanpa melakukan apa-apa",
      ],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    steps = [
      keyFlag,
      keyReport,
      keyQuestion,
      keyOptions,
      keyFinish,
      keyNumberNav,
      keyPrev,
      keyTimer,
      keyNext,
    ];
  }

  /// Mulai showcase
  void startShowcase(BuildContext context) {
    if (_started) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase(steps);
      _started = true;
      currentStep = 0;
    });
  }

  /// Reset biar bisa dipanggil ulang
  void restartShowcase(BuildContext context) {
    _started = false;
    startShowcase(context);
  }

  /// Timer
  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        t.cancel();
        Get.snackbar("Waktu Habis", "Waktu pengerjaan telah habis (dummy).");
      }
    });
  }

  /// Answer selection
  void selectAnswer(int soalNomor, int opsiIndex) {
    answers[soalNomor] = opsiIndex;
  }

  void toggleFlag(int soalNomor) {
    if (flagged.contains(soalNomor)) {
      flagged.remove(soalNomor);
    } else {
      flagged.add(soalNomor);
    }
    flagged.refresh();
  }

  void toggleBookmark(int soalNomor) {
    if (bookmarked.contains(soalNomor)) {
      bookmarked.remove(soalNomor);
    } else {
      bookmarked.add(soalNomor);
    }
    bookmarked.refresh();
  }

  /// Navigasi soal
  void goNext() {
    if (currentIndex.value < soalList.length - 1) currentIndex.value++;
  }

  void goPrev() {
    if (currentIndex.value > 0) currentIndex.value--;
  }

  void jumpTo(int idx) {
    if (idx >= 0 && idx < soalList.length) currentIndex.value = idx;
  }

  /// Navigasi showcase (tour)
  void goNextShow(BuildContext context) {
    if (currentStep < steps.length - 1) {
      currentStep++;
      ShowCaseWidget.of(context).startShowCase([steps[currentStep]]);
      print("Next step: $currentStep");
    } else {
      // jika ini langkah terakhir, langsung keluar
      print("Showcase selesai, otomatis kembali");
      Get.back();
    }
  }

  void goPrevShow(BuildContext context) {
    if (currentStep > 0) {
      currentStep--;
      ShowCaseWidget.of(context).startShowCase([steps[currentStep]]);
      print("Prev step: $currentStep");
    }
  }

  void onFinishTour() {
    Get.back();
    print("Tour selesai 🎉");
  }

  /// Format timer
  String formatTime(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return "$mm:$ss";
  }

  /// Dummy submit
  void finish() {
    Get.snackbar("Selesai", "Jawaban tersimpan (dummy).");
  }
}

/// Data model soal
class Soal {
  final int nomor;
  final String judul;
  final String pertanyaan;
  final List<String> opsi;

  Soal({
    required this.nomor,
    required this.judul,
    required this.pertanyaan,
    required this.opsi,
  });
}
