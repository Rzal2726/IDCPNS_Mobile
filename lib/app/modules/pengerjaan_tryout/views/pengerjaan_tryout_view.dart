import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/pengerjaan_tryout_controller.dart';

class PengerjaanTryoutView extends GetView<PengerjaanTryoutController> {
  const PengerjaanTryoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                      horizontal: 24,
                      vertical: 12,
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
                          () => Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 16,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 16,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: 12,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Apakah kamu yakin ingin menyelesaikan tryout?",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor:
                                                Colors.black, // warna teks/icon
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                Colors.white, // warna teks/icon
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black, // warna teks/icon
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    if (controller.currentQuestion.value > 0) {
                      controller.currentQuestion.value--;
                      controller.startQuestion(
                        controller.soalList[controller
                            .currentQuestion
                            .value]['id'],
                      );
                    }
                  },
                  child: Row(
                    children: [Icon(Icons.arrow_back_ios), Text("Sebelumnya")],
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
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black, // warna teks/icon
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    if (controller.currentQuestion.value <
                        controller.soalList.length - 1) {
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
      body: SingleChildScrollView(
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
                                  return Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "List Nomor Soal",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Expanded(
                                          child: Obx(
                                            () =>
                                                controller.soalList.isEmpty
                                                    ? Skeletonizer(
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          foregroundColor:
                                                              Colors.black,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 24,
                                                                vertical: 12,
                                                              ),
                                                        ),
                                                        onPressed: () {},
                                                        child: const Text("5"),
                                                      ),
                                                    )
                                                    : GridView.builder(
                                                      itemCount:
                                                          controller
                                                              .soalList
                                                              .length,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount:
                                                                5, // jumlah kolom
                                                            crossAxisSpacing: 4,
                                                            mainAxisSpacing: 4,
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
                                                            backgroundColor:
                                                                controller
                                                                        .checkMark(
                                                                          soal,
                                                                        )
                                                                    ? Colors
                                                                        .amber
                                                                        .shade100
                                                                    : controller
                                                                        .checkAnswer(
                                                                          soal['id'],
                                                                        )
                                                                    ? Colors
                                                                        .teal
                                                                        .shade100
                                                                    : Colors
                                                                        .white,
                                                            foregroundColor:
                                                                Colors.black,
                                                            shape: RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                color:
                                                                    Colors
                                                                        .transparent,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 12,
                                                                ),
                                                          ),
                                                          onPressed: () {
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

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Tombol Back
                          IconButton(
                            onPressed:
                                controller.currentQuestion.value > 0
                                    ? () {
                                      controller.currentQuestion.value--;
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
                            if (questionNumber > controller.soalList.length) {
                              return SizedBox.shrink();
                            }

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      controller.checkMark(
                                            controller.soalList[questionNumber -
                                                1],
                                          )
                                          ? Colors.amber
                                          : controller.checkAnswer(
                                            controller.soalList[questionNumber -
                                                1]['id'],
                                          )
                                          ? Color.fromARGB(255, 208, 255, 244)
                                          : controller.currentQuestion.value ==
                                              questionNumber - 1
                                          ? Colors.green.shade100
                                          : Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 4,
                                  ),
                                ),
                                onPressed: () {
                                  controller.currentQuestion.value =
                                      questionNumber - 1;
                                  controller.startQuestion(
                                    controller.soalList[controller
                                        .currentQuestion
                                        .value]['id'],
                                  );
                                },
                                child: Text(questionNumber.toString()),
                              ),
                            );
                          }),

                          // Tombol Next
                          IconButton(
                            onPressed:
                                (controller.currentQuestion.value + 1) <
                                        controller.soalList.length
                                    ? () {
                                      controller.currentQuestion.value++;
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
                                icon: Icon(Icons.flag, color: Colors.redAccent),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                                                : Icons.bookmark_add_outlined,
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
                                      return Padding(
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
                                            mainAxisSize: MainAxisSize.min,
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
                                                        () => Navigator.pop(
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
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              TextField(
                                                controller:
                                                    controller
                                                        .laporanController,
                                                maxLines: 6,
                                                decoration: InputDecoration(
                                                  hintText: "Isi laporan...",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.all(12),
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
                                                        "Alert",
                                                        "Mohon isi laporan terlebih dahulu",
                                                        backgroundColor:
                                                            Colors.pink,
                                                        colorText: Colors.white,
                                                      );
                                                      return;
                                                    }
                                                    controller.sendLaporSoal(
                                                      questionId: soal['id'],
                                                      laporan:
                                                          controller
                                                              .laporanController
                                                              .text,
                                                      context: context,
                                                    );

                                                    Navigator.pop(context);
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
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Soal text
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: Html(data: soal['soal'] ?? ""),
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
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: RadioListTile(
                                value: option['id'],
                                groupValue: selectedAnswer,
                                onChanged: (val) {
                                  controller.saveAnswer(
                                    questionId: soal['id'],
                                    optionId: option['id'],
                                    waktuPengerjaan: controller.getWaktuSoal(
                                      soal['id'],
                                    ),
                                  );
                                  controller.selectedAnswers[controller
                                          .currentQuestion
                                          .value] =
                                      val;
                                },
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                            lineHeight: LineHeight.number(1.3),
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
    );
  }
}
