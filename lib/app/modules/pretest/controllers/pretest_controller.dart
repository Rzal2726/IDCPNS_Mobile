import 'dart:async';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class PretestController extends GetxController {
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

  var currentIndex = 0.obs;
  var answers = <int, int>{}.obs; // nomor -> opsiIndex
  var flagged = <int>{}.obs; // set nomor soal yang diflag
  var bookmarked = <int>{}.obs; // set soal yg di-bookmark (bookmark icon)
  var remainingSeconds = (5 * 60).obs; // 5 minutes default

  Timer? _timer; // 5 menit (dummy)

  final count = 0.obs;
  @override
  void onInit() {
    startTimer();
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

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        t.cancel();
        // time's up -> optional: auto submit
        Get.snackbar("Waktu Habis", "Waktu pengerjaan telah habis (dummy).");
      }
    });
  }

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
    Get.toNamed(Routes.PRETEST_RESULT);
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
