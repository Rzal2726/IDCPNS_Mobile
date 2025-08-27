import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class PanduanTryoutController extends GetxController {
  //TODO: Implement PanduanTryoutController
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
              padding: const EdgeInsets.only(top: 80.0),
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
              padding: const EdgeInsets.only(bottom: 280.0),
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
              padding: const EdgeInsets.only(top: 280.0),
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
