import 'dart:async'; // <- penting untuk Timer
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class PretestTourController extends GetxController {
  // Semua soal contoh
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

  // reactive state
  var currentIndex = 0.obs;
  var answers = <int, int>{}.obs; // nomor -> opsiIndex
  var flagged = <int>{}.obs; // set nomor soal yang diflag
  var bookmarked = <int>{}.obs; // set soal yg di-bookmark (bookmark icon)
  var remainingSeconds = 300.obs; // 5 minutes default

  Timer? _timer; // 5 menit (dummy)
  final count = 0.obs;

  // -----------------------------
  // SHOWCASE KEYS (disimpan di controller)
  // urutannya mengikuti permintaan:
  // 1. tandai (bookmark) -> 2. laporkan (flag) -> 3. field soal -> 4. opsi ->
  // 5. tombol selesai (appbar) -> 6. pagination -> 7. tombol sebelumnya -> 8. durasi -> 9. tombol next
  // -----------------------------
  final GlobalKey kBookmark = GlobalKey();
  final GlobalKey kFlag = GlobalKey();
  final GlobalKey kSoalField = GlobalKey();
  final GlobalKey kOptions = GlobalKey();
  final GlobalKey kFinish = GlobalKey();
  final GlobalKey kPagination = GlobalKey();
  final GlobalKey kPrev = GlobalKey();
  final GlobalKey kTimer = GlobalKey();
  final GlobalKey kNext = GlobalKey();

  List<GlobalKey> get showcaseKeys => [
    kBookmark,
    kFlag,
    kSoalField,
    kOptions,
    kFinish,
    kPagination,
    kPrev,
    kTimer,
    kNext,
  ];

  bool _showcaseStarted = false; // mencegah start ganda

  // helper: mulai showcase dari controller (panggil dari view dengan context)
  void startShowcase(BuildContext ctx, {bool force = false}) {
    if (_showcaseStarted && !force) return;
    try {
      final widget = ShowCaseWidget.of(ctx);
      widget?.startShowCase(showcaseKeys);
      _showcaseStarted = true;
    } catch (e) {
      // kalau gagal (mis. belum ada ShowCaseWidget di tree), abaikan
    }
  }

  // optional: reset flag agar bisa di-start lagi
  void resetShowcase() {
    _showcaseStarted = false;
  }

  // -----------------------------
  // lifecycle & timer
  // -----------------------------
  @override
  void onInit() {
    startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startShowcase(Get.context!);
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // jalankan showcase setelah widget siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startShowcase(Get.context!);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        t.cancel();
        // time's up -> optional: auto submit
        Get.snackbar("Waktu Habis", "Waktu pengerjaan telah habis (dummy).");
      }
    });
  }

  // -----------------------------
  // functional methods
  // -----------------------------
  void selectAnswer(int soalNomor, int opsiIndex) {
    answers[soalNomor] = opsiIndex;
  }

  void toggleFlag(int soalNomor) {
    if (flagged.contains(soalNomor))
      flagged.remove(soalNomor);
    else
      flagged.add(soalNomor);
    flagged.refresh();
  }

  void toggleBookmark(int soalNomor) {
    if (bookmarked.contains(soalNomor))
      bookmarked.remove(soalNomor);
    else
      bookmarked.add(soalNomor);
    bookmarked.refresh();
  }

  void goNext() {
    if (currentIndex.value < soalList.length - 1) currentIndex.value++;
  }

  void goPrev() {
    if (currentIndex.value > 0) currentIndex.value--;
  }

  void jumpTo(int idx) {
    if (idx >= 0 && idx < soalList.length) currentIndex.value = idx;
  }

  String formatTime(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return "$mm:$ss";
  }

  void finish() {
    // dummy submit
    Get.snackbar("Selesai", "Jawaban tersimpan (dummy).");
  }

  void report(int soalNomor) {
    Get.defaultDialog(
      title: 'Laporkan Soal',
      middleText: 'Anda ingin melaporkan soal nomor $soalNomor?',
      textCancel: 'Batal',
      textConfirm: 'Laporkan',
      onConfirm: () {
        Get.back(); // tutup dialog
        Get.snackbar(
          'Dilaporkan',
          'Soal nomor $soalNomor telah dilaporkan (dummy).',
        );
      },
    );
  }
}

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
