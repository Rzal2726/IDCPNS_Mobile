import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/htmlResponsive/responsive_html.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/pengerjaan_tryout_controller.dart';

class PengerjaanTryoutView extends GetView<PengerjaanTryoutController> {
  const PengerjaanTryoutView({super.key});
  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop(BuildContext context) async {
      bool? exitApp = await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        context: context,
        builder: (context) {
          return Obx(
            () => SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Text(
                              "Apakah kamu yakin ingin menyelesaikan tryout?",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Soal"),
                          Text(
                            "${controller.soalList.length.toString()} Soal",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Terjawab"),
                          Text(
                            "${controller.selectedAnswersList.where((answer) => answer['tryout_question_option_id'] != 0).length.toString()} Soal",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tidak Terjawab"),
                          Text(
                            "${(controller.soalList.length - controller.selectedAnswersList.where((answer) => answer['tryout_question_option_id'] != 0).length).toString()} Soal",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Ditandai"),
                          Text(
                            "${(controller.markedList.length).toString()} Soal",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor:
                                    Colors.black, // warna teks/icon
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cek Kembali",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12), // jarak antar tombol
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.teal, // warna tombol kedua
                                foregroundColor:
                                    Colors.white, // warna teks/icon
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed: () async {
                                await controller.submitSoal();
                              },
                              child: const Text(
                                "Kirim Jawaban",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      // showDialog(
      //   context: context,
      //   builder:
      //       (context) =>
      //           AlertDialog(
      //         backgroundColor: Colors.white,
      //         title: const Text('Konfirmasi'),
      //         content: const Text(
      //           "Apakah kamu yakin ingin kembali?\nProgres tryout yang belum selesai akan hilang.",
      //         ),
      //         actions: [
      //           TextButton(
      //             onPressed: () => Navigator.of(context).pop(false),
      //             child: const Text('Batal'),
      //           ),
      //           ElevatedButton(
      //             onPressed: () {
      //               Navigator.of(context).pop(false);
      //               Get.back();
      //             },
      //             style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
      //             child: const Text(
      //               'Ya',
      //               style: TextStyle(color: Colors.white),
      //             ),
      //           ),
      //         ],
      //       ),
      // );

      return exitApp ?? false; // false = jangan keluar
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          bool canExit = await _onWillPop(context);
          if (canExit) {
            controller.localStorage.remove("selected_answer_list");
            controller.localStorage.remove("selected_answer");
            controller.localStorage.remove("soal_uuid");
            controller.localStorage.remove("sisa_durasi");
            Get.back(); // keluar manual
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              title: Text("Pengerjaan Tryout"),
              actions: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal, // warna tombol
                          foregroundColor: Colors.white, // warna teks/icon
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return Obx(
                                () => SafeArea(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      top: 16,
                                      bottom:
                                          MediaQuery.of(
                                            context,
                                          ).viewInsets.bottom +
                                          16,
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        spacing: 12,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 250,
                                                child: Text(
                                                  "Apakah kamu yakin ingin menyelesaikan tryout?",
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.close),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Total Soal"),
                                              Text(
                                                "${controller.soalList.length.toString()} Soal",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Terjawab"),
                                              Text(
                                                "${controller.selectedAnswersList.where((answer) => answer['tryout_question_option_id'] != 0).length.toString()} Soal",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Tidak Terjawab"),
                                              Text(
                                                "${(controller.soalList.length - controller.selectedAnswersList.where((answer) => answer['tryout_question_option_id'] != 0).length).toString()} Soal",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Ditandai"),
                                              Text(
                                                "${(controller.markedList.length).toString()} Soal",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor:
                                                        Colors
                                                            .black, // warna teks/icon
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 14,
                                                        ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cek Kembali",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ), // jarak antar tombol
                                              Expanded(
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors
                                                            .teal, // warna tombol kedua
                                                    foregroundColor:
                                                        Colors
                                                            .white, // warna teks/icon
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 14,
                                                        ),
                                                  ),
                                                  onPressed: () async {
                                                    await controller
                                                        .submitSoal();
                                                  },
                                                  child: const Text(
                                                    "Kirim Jawaban",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text("Selesai"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Column(
            spacing: 4,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey)),
                ),
              ),
              Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white, // warna teks/icon
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () {
                      if (controller.currentQuestion.value > 0) {
                        controller.markAnswer(
                          controller.currentQuestion.value,
                          controller.checkIsAnswered(
                            controller.currentQuestion.value,
                          ),
                        );
                        controller.currentQuestion.value--;
                        controller.startQuestion(
                          controller.soalList[controller
                              .currentQuestion
                              .value]['id'],
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Text("Sebelumnya"),
                      ],
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.formattedTime,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white, // warna teks/icon
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () {
                      if (controller.currentQuestion.value <
                          controller.soalList.length - 1) {
                        controller.markAnswer(
                          controller.currentQuestion.value,
                          controller.checkIsAnswered(
                            controller.currentQuestion.value,
                          ),
                        );
                        controller.currentQuestion.value++;
                        controller.startQuestion(
                          controller.soalList[controller
                              .currentQuestion
                              .value]['id'],
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Text("Selanjutnya"),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Nomor Soal",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (context) {
                                      return SafeArea(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Container(
                                            margin: EdgeInsets.all(16),
                                            child: Column(
                                              spacing: 16,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "List Nomor Soal",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Expanded(
                                                  child: Obx(
                                                    () =>
                                                        controller
                                                                .soalList
                                                                .isEmpty
                                                            ? Skeletonizer(
                                                              child: ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            24,
                                                                        vertical:
                                                                            12,
                                                                      ),
                                                                ),
                                                                onPressed:
                                                                    () {},
                                                                child:
                                                                    const Text(
                                                                      "5",
                                                                    ),
                                                              ),
                                                            )
                                                            : GridView.builder(
                                                              itemCount:
                                                                  controller
                                                                      .soalList
                                                                      .length,
                                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    5, // jumlah kolom
                                                                crossAxisSpacing:
                                                                    16,
                                                                mainAxisSpacing:
                                                                    16,
                                                              ),
                                                              itemBuilder: (
                                                                context,
                                                                index,
                                                              ) {
                                                                final soal =
                                                                    controller
                                                                        .soalList[index];
                                                                return ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    elevation:
                                                                        0,
                                                                    backgroundColor:
                                                                        controller.checkMark(
                                                                              soal,
                                                                            )
                                                                            ? Colors.amber
                                                                            : controller.checkAnswer(
                                                                              soal['id'],
                                                                            )
                                                                            ? Colors.teal
                                                                            : controller.viewedQuestions.contains(
                                                                              controller.soalList.indexOf(
                                                                                soal,
                                                                              ),
                                                                            )
                                                                            ? Colors.grey
                                                                            : Colors.white,
                                                                    foregroundColor:
                                                                        controller.checkMark(
                                                                              soal,
                                                                            )
                                                                            ? Colors.black
                                                                            : controller.checkAnswer(
                                                                              soal['id'],
                                                                            )
                                                                            ? Colors.white
                                                                            : controller.viewedQuestions.contains(
                                                                              controller.soalList.indexOf(
                                                                                soal,
                                                                              ),
                                                                            )
                                                                            ? Colors.white
                                                                            : Colors.black,
                                                                    shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                        color:
                                                                            Colors.grey,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                    ),
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    controller.markAnswer(
                                                                      controller
                                                                          .currentQuestion
                                                                          .value,
                                                                      controller.checkIsAnswered(
                                                                        controller
                                                                            .currentQuestion
                                                                            .value,
                                                                      ),
                                                                    );
                                                                    controller
                                                                        .currentQuestion
                                                                        .value = index;
                                                                    controller.startQuestion(
                                                                      controller
                                                                          .soalList[controller
                                                                          .currentQuestion
                                                                          .value]['id'],
                                                                    );
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    controller
                                                                        .soalList[index]['no_soal']
                                                                        .toString(),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.list, color: Colors.teal),
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          // Pastikan currentPage sinkron dengan currentQuestion
                          int pageIndex =
                              controller.currentQuestion.value ~/
                              controller.numberPerPage.value;
                          if (controller.currentPage.value != pageIndex) {
                            controller.currentPage.value = pageIndex;
                          }

                          int totalPages =
                              (controller.soalList.length /
                                      controller.numberPerPage.value)
                                  .ceil();

                          return Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 2,
                            children: [
                              // Tombol Back
                              IconButton(
                                onPressed:
                                    controller.currentPage.value > 0
                                        ? () {
                                          controller.currentPage.value--;
                                          int newQuestionIndex =
                                              controller.currentPage.value *
                                              controller.numberPerPage.value;
                                          newQuestionIndex = newQuestionIndex
                                              .clamp(
                                                0,
                                                controller.soalList.length - 1,
                                              );
                                          controller.markAnswer(
                                            controller.currentQuestion.value,
                                            controller.checkIsAnswered(
                                              controller.currentQuestion.value,
                                            ),
                                          );
                                          controller.currentQuestion.value =
                                              newQuestionIndex;
                                          controller.startQuestion(
                                            controller
                                                .soalList[newQuestionIndex]['id'],
                                          );
                                        }
                                        : null,
                                icon: const Icon(Icons.arrow_back_ios),
                              ),

                              // Tombol nomor soal di page saat ini
                              ...List.generate(controller.numberPerPage.value, (
                                index,
                              ) {
                                int questionNumber =
                                    controller.currentPage.value *
                                        controller.numberPerPage.value +
                                    (index + 1);

                                // Cek kalau questionNumber > jumlah soal
                                if (questionNumber >
                                    controller.soalList.length) {
                                  return SizedBox.shrink();
                                }

                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        controller.checkMark(
                                              controller
                                                  .soalList[questionNumber - 1],
                                            )
                                            ? Colors.amber
                                            : controller.checkAnswer(
                                              controller
                                                  .soalList[questionNumber -
                                                  1]['id'],
                                            )
                                            ? Colors.teal
                                            : controller
                                                    .currentQuestion
                                                    .value ==
                                                questionNumber - 1
                                            ? Colors.teal.shade200
                                            : controller.viewedQuestions
                                                .contains(questionNumber - 1)
                                            ? Colors.grey
                                            : Colors.white,
                                    foregroundColor:
                                        controller.checkMark(
                                              controller
                                                  .soalList[questionNumber - 1],
                                            )
                                            ? Colors.black
                                            : controller.checkAnswer(
                                              controller
                                                  .soalList[questionNumber -
                                                  1]['id'],
                                            )
                                            ? Colors.white
                                            : controller.viewedQuestions
                                                .contains(questionNumber - 1)
                                            ? Colors.white
                                            : Colors.black,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.markAnswer(
                                      controller.currentQuestion.value,
                                      controller.checkIsAnswered(
                                        controller.currentQuestion.value,
                                      ),
                                    );
                                    controller.currentQuestion.value =
                                        questionNumber - 1;
                                    controller.startQuestion(
                                      controller.soalList[controller
                                          .currentQuestion
                                          .value]['id'],
                                    );
                                  },
                                  child: Text(questionNumber.toString()),
                                );
                              }),

                              // Tombol Next
                              IconButton(
                                onPressed:
                                    controller.currentPage.value <
                                            totalPages - 1
                                        ? () {
                                          controller.currentPage.value++;
                                          int newQuestionIndex =
                                              controller.currentPage.value *
                                              controller.numberPerPage.value;
                                          newQuestionIndex = newQuestionIndex
                                              .clamp(
                                                0,
                                                controller.soalList.length - 1,
                                              );
                                          controller.markAnswer(
                                            controller.currentQuestion.value,
                                            controller.checkIsAnswered(
                                              controller.currentQuestion.value,
                                            ),
                                          );
                                          controller.currentQuestion.value =
                                              newQuestionIndex;
                                          controller.startQuestion(
                                            controller
                                                .soalList[newQuestionIndex]['id'],
                                          );
                                        }
                                        : null,
                                icon: const Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  // Kalau soal masih kosong -> tampilkan skeleton
                  if (controller.soalList.isEmpty) {
                    return Skeletonizer(
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Soal No.X",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.bookmark,
                                      color: Colors.amberAccent,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.flag,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  // Ambil soal aktif
                  final soal =
                      controller.soalList[controller.currentQuestion.value];

                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Header soal
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Soal No.${soal['no_soal']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Obx(
                                    () =>
                                        controller.soalList.isNotEmpty
                                            ? IconButton(
                                              onPressed: () {
                                                controller.markSoal(soal);
                                              },
                                              icon: Icon(
                                                controller.checkMark(soal)
                                                    ? Icons.bookmark_remove
                                                    : Icons
                                                        .bookmark_add_outlined,
                                                color: Colors.amberAccent,
                                              ),
                                            )
                                            : SizedBox(),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.flag,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16),
                                          ),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return SafeArea(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 16,
                                                bottom:
                                                    MediaQuery.of(
                                                      context,
                                                    ).viewInsets.bottom +
                                                    16,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    // Header modal
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          "Laporkan Soal",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.close,
                                                          ),
                                                          onPressed:
                                                              () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(height: 1),
                                                    const SizedBox(height: 12),
                                                    Text(
                                                      "Silahkan isi form di bawah untuk melaporkan soal:",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    TextField(
                                                      controller:
                                                          controller
                                                              .laporanController,
                                                      maxLines: 6,
                                                      decoration: InputDecoration(
                                                        hintText:
                                                            "Isi laporan...",
                                                        border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        contentPadding:
                                                            const EdgeInsets.all(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.teal,
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 14,
                                                              ),
                                                        ),
                                                        onPressed: () {
                                                          if (controller
                                                                  .laporanController
                                                                  .text
                                                                  .length <
                                                              1) {
                                                            Get.snackbar(
                                                              "Gagal",
                                                              "Mohon isi laporan terlebih dahulu",
                                                              backgroundColor:
                                                                  Colors.pink,
                                                              colorText:
                                                                  Colors.white,
                                                            );
                                                            return;
                                                          }
                                                          controller.sendLaporSoal(
                                                            questionId:
                                                                soal['id'],
                                                            laporan:
                                                                controller
                                                                    .laporanController
                                                                    .text,
                                                            context: context,
                                                          );

                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                        child: const Text(
                                                          "Kirim Laporan",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Container(
                            margin: const EdgeInsets.all(8),
                            child: buildSmartHtml(soal['soal'] ?? ""),
                            // Html(
                            //   data: soal['soal'] ?? "",
                            //   extensions: [
                            //     TagExtension(
                            //       tagsToExtend: {"img"}, // khusus untuk <img>
                            //       builder: (context) {
                            //         final src = context.attributes['src'] ?? '';
                            //         return SingleChildScrollView(
                            //           scrollDirection: Axis.horizontal,
                            //           child: Image.network(
                            //             src,
                            //             fit: BoxFit.contain,
                            //             errorBuilder:
                            //                 (context, error, stackTrace) =>
                            //                     const Icon(
                            //                       Icons.broken_image,
                            //                       color: Colors.red,
                            //                     ),
                            //           ),
                            //         );
                            //       },
                            //     ),
                            //   ],
                            // ),
                          ),

                          const SizedBox(height: 24),

                          // List opsi jawaban
                          Obx(() {
                            final selectedAnswer =
                                controller.selectedAnswers[controller
                                    .currentQuestion
                                    .value];
                            final options = soal['options'] as List;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options[index];
                                return Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: RadioListTile(
                                    value: option['id'],
                                    groupValue: selectedAnswer,
                                    onChanged: (val) {
                                      controller.saveAnswer(
                                        questionId: soal['id'],
                                        optionId: option['id'],
                                        waktuPengerjaan: controller
                                            .getWaktuSoal(soal['id']),
                                      );
                                      controller.selectedAnswers[controller
                                              .currentQuestion
                                              .value] =
                                          val;
                                      final normalMap = controller
                                          .selectedAnswers
                                          .map(
                                            (key, value) =>
                                                MapEntry(key.toString(), value),
                                          );

                                      controller.localStorage.setString(
                                        "selected_answer",
                                        jsonEncode(normalMap),
                                      );
                                      controller.localStorage.setString(
                                        "selected_answer_list",
                                        jsonEncode(
                                          controller.selectedAnswersList,
                                        ),
                                      );
                                    },
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${option['inisial']}.",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Html(
                                            data: option['jawaban'],
                                            style: {
                                              "p": Style(
                                                margin: Margins.all(0),
                                                padding: HtmlPaddings.all(0),
                                                fontSize: FontSize(14),
                                                lineHeight: LineHeight.number(
                                                  1.3,
                                                ),
                                              ),
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
