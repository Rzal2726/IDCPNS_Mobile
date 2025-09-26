import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// final List<Soal> soalList = [
//   Soal(
//     nomor: 1,
//     judul: "Pertemuan 1 - TWK",
//     pertanyaan:
//     "Sebagai pegawai kantoran, Anda memiliki delapan jam kerja aktif. Di lain sisi, Anda adalah seorang istri dan ibu dari dua balita. Bagaimana Anda mengatur tugas Anda sebagai pegawai dan ibu rumah tangga agar semua berjalan seimbang?",
//     opsi: [
//       "Selalu mendahulukan pekerjaan kantor karena sudah berkomitmen pada perusahaan",
//       "Mendahulukan kepentingan keluarga dibandingkan tugas kantor",
//       "Membagi waktu seadil-adilnya untuk keluarga dan pekerjaan",
//       "Mengerti posisinya dan mampu menyesuaikan diri di rumah maupun di kantor",
//       "Melaksanakan tugas-tugas yang memang seharusnya dikerjakannya",
//     ],
//   ),
//   Soal(
//     nomor: 2,
//     judul: "Pertemuan 2 - TIU",
//     pertanyaan:
//     "Anda diberi tanggung jawab untuk memimpin sebuah tim proyek. Namun, beberapa anggota tim tidak disiplin. Apa yang Anda lakukan?",
//     opsi: [
//       "Memberi teguran keras",
//       "Mengabaikan karena tidak penting",
//       "Memberikan contoh disiplin terlebih dahulu",
//       "Melaporkan ke atasan",
//       "Mencari anggota baru",
//     ],
//   ),
//   Soal(
//     nomor: 3,
//     judul: "Pertemuan 3 - TKP",
//     pertanyaan:
//     "Saat ujian CPNS online berlangsung, tiba-tiba koneksi internet Anda terganggu. Apa yang Anda lakukan?",
//     opsi: [
//       "Langsung panik",
//       "Mencoba menyalahkan panitia",
//       "Tetap tenang dan berusaha memperbaiki koneksi",
//       "Keluar ruangan",
//       "Menunggu tanpa melakukan apa-apa",
//     ],
//   ),
// ];
class PretestTourController extends GetxController {
  late TutorialCoachMark tutorialCoachMark;
  final count = 0.obs;
  final selesaiKey = GlobalKey();
  final nomorSoalKey = GlobalKey();
  final tandaiKey = GlobalKey();
  final flagKey = GlobalKey();
  final soalKey = GlobalKey();
  final optionKey = GlobalKey();
  final prevKey = GlobalKey();
  final nextKey = GlobalKey();
  final timerKey = GlobalKey();
  final opsi = [
    "Selalu mendahulukan pekerjaan kantor karena sudah berkomitmen pada perusahaan",
    "Mendahulukan kepentingan keluarga dibandingkan tugas kantor",
    "Membagi waktu seadil-adilnya untuk keluarga dan pekerjaan",
    "Mengerti posisinya dan mampu menyesuaikan diri di rumah maupun di kantor",
    "Melaksanakan tugas-tugas yang memang seharusnya dikerjakannya",
  ];
  List<TargetFocus> targets = [];
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

  List<String> contohOpsi = [
    "Jawaban A - Lorem ipsum dolor sit amet.",
    "Jawaban B - Consectetur adipiscing elit.",
    "Jawaban C - Sed do eiusmod tempor.",
    "Jawaban D - Ut labore et dolore magna aliqua.",
  ];
  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Button1",
        keyTarget: tandaiKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Text(
              "Tandai soal apabila tidak dijawab/dilewat.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Button2",
        keyTarget: flagKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Text(
              "Laporkan soal apabila ada kekeliruan.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "FAB",
        keyTarget: soalKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: const Text(
                "Konten soal yang ditanyakan.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Option",
        keyTarget: optionKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: const Text(
                "Opsi jawaban yang harus dipilih.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "selesai",
        keyTarget: selesaiKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: const Text(
                "Menyelesaikan tryout dan mengirim jawaban.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "nomorSoal",
        keyTarget: nomorSoalKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Padding(
              padding: const EdgeInsets.only(top: 240.0),
              child: const Text(
                "Navigasi urutan soal.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "prevSoal",
        keyTarget: prevKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: const Text(
                "Navigasi untuk menampilkan soal sebelumnya.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "nextSoal",
        keyTarget: nextKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: const Text(
                "Navigasi untuk menampilkan soal selanjutnya.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "timer",
        keyTarget: timerKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: const Text(
                "Menampilkan sisa durasi pengerjaan tryout.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showTutorial(BuildContext context) {
    if (targets.isNotEmpty) {
      tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.black,
        paddingFocus: 10,
        opacityShadow: 0.8,
        onFinish: () {
          Get.back();
        },
        hideSkip: true,
      )..show(context: context);
    } else {
      return;
    }
  }
}
