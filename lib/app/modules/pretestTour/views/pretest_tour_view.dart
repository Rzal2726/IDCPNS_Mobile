import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/show_case_widget.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:showcaseview/showcaseview.dart';

import '../controllers/pretest_tour_controller.dart';

class PretestTourView extends GetView<PretestTourController> {
  const PretestTourView({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) {
        controller.startShowcase(context); // panggil showcase dari controller

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            leading: BackButton(),
            title: Text(
              "Pretest",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8,
                ),
                child: ShowCaseView(
                  globalKey: controller.keyFinish,
                  description: "Menyelesaikan tryout dan mengirim jawaban.",
                  child: ElevatedButton(
                    onPressed: controller.finish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      "Selesai",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // layout: content (scroll) + bottom fixed navigation
          body: SafeArea(
            child: Column(
              children: [
                // Expanded content (scrollable)
                Expanded(
                  child: Obx(() {
                    final soal =
                        controller.soalList[controller.currentIndex.value];

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        children: [
                          // Nomor Soal card with chevrons + small boxes
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Header: Nomor Soal + Icon
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Nomor Soal",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.format_list_bulleted,
                                        color: Colors.teal,
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 12),

                                  // Navigator soal
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Left chevron
                                      ShowCaseView(
                                        globalKey: controller.keyNumberNav,
                                        description:
                                            "Navigasi urutan no. soal.",
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 34,
                                              height: 34,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.teal,
                                                  width: 1.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: IconButton(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                padding: EdgeInsets.zero,
                                                onPressed: controller.goPrev,
                                                icon: Icon(
                                                  Icons.chevron_left,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),

                                            // Nomor soal
                                            Row(
                                              children: List.generate(
                                                controller.soalList.length,
                                                (i) {
                                                  final isActive =
                                                      controller
                                                          .currentIndex
                                                          .value ==
                                                      i;

                                                  return GestureDetector(
                                                    onTap:
                                                        () => controller.jumpTo(
                                                          i,
                                                        ),
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                          ),
                                                      width: 34,
                                                      height: 34,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              isActive
                                                                  ? Colors.teal
                                                                  : Colors.grey,
                                                        ),
                                                        color:
                                                            isActive
                                                                ? Colors
                                                                    .teal
                                                                    .shade50
                                                                : Colors.white,
                                                      ),
                                                      child: Text(
                                                        "${controller.soalList[i].nomor}",
                                                        style: TextStyle(
                                                          color:
                                                              isActive
                                                                  ? Colors.teal
                                                                  : Colors
                                                                      .black87,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                            // Right chevron
                                            Container(
                                              width: 34,
                                              height: 34,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.teal,
                                                  width: 1.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: IconButton(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                padding: EdgeInsets.zero,
                                                onPressed: controller.goNext,
                                                icon: Icon(
                                                  Icons.chevron_right,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 14),

                          // Soal card
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // title row: Soal No + bookmark & flag
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          soal.judul,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      // bookmark icon
                                      ShowCaseView(
                                        globalKey: controller.keyFlag,
                                        description:
                                            "Tandai soal apabila tidak dijawab/dilewat.",
                                        child: IconButton(
                                          onPressed:
                                              () => controller.toggleBookmark(
                                                soal.nomor,
                                              ),
                                          icon: Obx(
                                            () => Icon(
                                              controller.bookmarked.contains(
                                                    soal.nomor,
                                                  )
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_border,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // flag icon
                                      ShowCaseView(
                                        globalKey: controller.keyReport,
                                        description:
                                            "Laporkan soal apabila ada kekeliruan.",
                                        child: IconButton(
                                          onPressed:
                                              () => controller.toggleFlag(
                                                soal.nomor,
                                              ),
                                          icon: Obx(
                                            () => Icon(
                                              Icons.flag,
                                              color:
                                                  controller.flagged.contains(
                                                        soal.nomor,
                                                      )
                                                      ? Colors.redAccent
                                                      : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8),
                                  ShowCaseView(
                                    globalKey: controller.keyQuestion,

                                    description: "Konten soal yang ditanyakan.",
                                    child: Text(
                                      soal.pertanyaan,
                                      style: TextStyle(height: 1.4),
                                    ),
                                  ),
                                  SizedBox(height: 16),

                                  // options
                                  ShowCaseView(
                                    globalKey: controller.keyOptions,

                                    description:
                                        "Opsi jawaban yang harus dipilih.",
                                    child: Column(
                                      children: List.generate(
                                        soal.opsi.length,
                                        (i) {
                                          return Obx(() {
                                            final isSelected =
                                                controller.answers[soal
                                                        .nomor] !=
                                                    null &&
                                                controller.answers[soal
                                                        .nomor] ==
                                                    i;

                                            return Container(
                                              margin: EdgeInsets.only(
                                                bottom: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color:
                                                      isSelected
                                                          ? Colors.teal
                                                          : Colors
                                                              .grey
                                                              .shade300,
                                                ),
                                              ),
                                              child: RadioListTile<int>(
                                                dense: true,
                                                value: i,
                                                groupValue:
                                                    controller.answers[soal
                                                        .nomor],
                                                onChanged: (val) {
                                                  controller.selectAnswer(
                                                    soal.nomor,
                                                    i,
                                                  );
                                                },
                                                title: Text(
                                                  soal.opsi[i],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 24),
                        ],
                      ),
                    );
                  }),
                ),

                // Bottom fixed navigation
                Obx(() {
                  final disablePrev = controller.currentIndex.value == 0;
                  final disableNext =
                      controller.currentIndex.value ==
                      controller.soalList.length - 1;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Sebelumnya
                        ShowCaseView(
                          globalKey: controller.keyPrev,
                          description:
                              "Navigasi untuk menampilkan soal sebelumnya.",
                          child: ElevatedButton(
                            onPressed: disablePrev ? null : controller.goPrev,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  disablePrev
                                      ? Colors.grey.shade200
                                      : Colors.white,
                              foregroundColor:
                                  disablePrev ? Colors.grey : Colors.black,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.chevron_left, size: 18),
                                SizedBox(width: 4),
                                Text("Sebelumnya"),
                              ],
                            ),
                          ),
                        ),

                        Spacer(),

                        // Timer
                        ShowCaseView(
                          globalKey: controller.keyTimer,
                          description:
                              "Menampilkan sisa durasi pengerjaan Pretest.",
                          child: Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Text(
                                controller.formatTime(
                                  controller.remainingSeconds.value,
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Spacer(),

                        // Selanjutnya
                        ShowCaseView(
                          globalKey: controller.keyNext,
                          description:
                              "Navigasi untuk menampilkan soal selanjutnya.",
                          child: ElevatedButton(
                            onPressed: disableNext ? null : controller.goNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  disableNext
                                      ? Colors.grey.shade400
                                      : Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text("Selanjutnya"),
                                SizedBox(width: 6),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
