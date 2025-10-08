import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/exitDialog.dart';
import 'package:idcpns_mobile/app/Components/widgets/exitPretetsNotif.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/pretest_controller.dart';

class PretestView extends GetView<PretestController> {
  const PretestView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // biar kita handle pop sendiri
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final confirm = await showExitDialog(context);
        if (confirm) {
          Navigator.of(context).pop(); // keluar halaman
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text("Pengerjaan Bimbel"),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return SafeArea(
                            child: RefreshIndicator(
                              color: Colors.teal,
                              backgroundColor: Colors.white,
                              onRefresh: () => controller.refresh(),
                              child: Obx(
                                () => Padding(
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
                                    physics: AlwaysScrollableScrollPhysics(),
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
                                            Text(
                                              "Apakah kamu yakin ingin menyelesaikan bimbel?",
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
                                              "${controller.selectedAnswersList.where((answer) => answer['pretest_soal_option_id'] != 0).length.toString()} Soal",
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
                                              "${(controller.soalList.length - controller.selectedAnswersList.where((answer) => answer['pretest_soal_option_id'] != 0).length).toString()} Soal",
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
                                                  backgroundColor: Colors.white,
                                                  foregroundColor:
                                                      Colors
                                                          .black, // warna teks/icon
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Cek Kembali",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
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
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 14,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  await controller.submitSoal();
                                                },
                                                child: Text(
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
                      padding: EdgeInsets.symmetric(
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
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Text("Sebelumnya"),
                      ],
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.formattedTime,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black, // warna teks/icon
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
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
        body: SafeArea(
          child: Obx(() {
            int pageIndex =
                controller.currentQuestion.value ~/
                controller.numberPerPage.value;

            if (controller.currentPage.value != pageIndex) {
              controller.currentPage.value = pageIndex;
            }
            if (controller.soalList.isEmpty) {
              return SizedBox.shrink();
            }

            final soal = controller.soalList[controller.currentQuestion.value];

            return SingleChildScrollView(
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
                                          padding: EdgeInsets.all(16),
                                          child: Container(
                                            margin: EdgeInsets.all(16),
                                            child: Column(
                                              spacing: 16,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "List Nomor Soal",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Expanded(
                                                  child:
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
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          24,
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                              ),
                                                              onPressed: () {},
                                                              child: Text("5"),
                                                            ),
                                                          )
                                                          : GridView.builder(
                                                            itemCount:
                                                                controller
                                                                    .soalList
                                                                    .length,
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                                                  elevation: 0,
                                                                  backgroundColor:
                                                                      controller.checkMark(
                                                                            soal,
                                                                          )
                                                                          ? Colors
                                                                              .amber
                                                                              .shade100
                                                                          : controller.checkAnswer(
                                                                            soal['id'],
                                                                          )
                                                                          ? Colors
                                                                              .teal
                                                                              .shade100
                                                                          : controller.isEmptyQuest(
                                                                            soal,
                                                                          )
                                                                          ? Colors
                                                                              .grey
                                                                              .shade300
                                                                          : Colors
                                                                              .white,

                                                                  foregroundColor:
                                                                      Colors
                                                                          .black,

                                                                  shape: RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                      color:
                                                                          controller.currentQuestion.value ==
                                                                                  index
                                                                              ? Colors
                                                                                  .teal // <- warna border kalau ini soal aktif
                                                                              : Colors.grey, // <- default
                                                                      width: 2,
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
                                                                        vertical:
                                                                            12,
                                                                      ),
                                                                ),
                                                                onPressed: () {
                                                                  // Mark soal lama dulu
                                                                  final currentSoal =
                                                                      controller
                                                                          .soalList[controller
                                                                          .currentQuestion
                                                                          .value];
                                                                  if (!controller
                                                                          .checkMark(
                                                                            currentSoal,
                                                                          ) &&
                                                                      !controller
                                                                          .checkAnswer(
                                                                            currentSoal['id'],
                                                                          )) {
                                                                    controller
                                                                        .markEmpty(
                                                                          currentSoal,
                                                                        );
                                                                  }

                                                                  // Pindah ke soal baru
                                                                  controller
                                                                      .currentQuestion
                                                                      .value = index;
                                                                  controller.startQuestion(
                                                                    controller
                                                                        .soalList[index]['id'],
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
                                              ],
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Tombol Back
                              IconButton(
                                onPressed: () {
                                  if (controller.currentQuestion.value > 0) {
                                    controller.currentQuestion.value--;

                                    // Ambil soal setelah pindah halaman
                                    int questionNumber =
                                        controller.currentPage.value;

                                    // Kalau soal sebelumnya gak di-mark & gak dijawab, tandai kosong
                                    if (!controller.checkMark(soal) &&
                                        !controller.checkAnswer(
                                          questionNumber,
                                        )) {
                                      controller.markEmpty(soal);
                                    }
                                  }
                                },

                                icon: Icon(Icons.arrow_back_ios),
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

                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          controller.checkMark(
                                                controller
                                                    .soalList[questionNumber -
                                                    1],
                                              )
                                              ? Colors.amber
                                              : controller.checkAnswer(
                                                controller
                                                    .soalList[questionNumber -
                                                    1]['id'],
                                              )
                                              ? const Color.fromARGB(
                                                255,
                                                208,
                                                255,
                                                244,
                                              )
                                              : controller
                                                      .currentQuestion
                                                      .value ==
                                                  questionNumber - 1
                                              ? Colors.green.shade100
                                              : controller.isEmptyQuest(
                                                controller
                                                    .soalList[questionNumber -
                                                    1],
                                              )
                                              ? Colors.grey.shade300
                                              : Colors.white,

                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
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

                                      // Kalau soal sebelumnya gak di-mark & gak dijawab, tandai kosong
                                      if (!controller.checkMark(soal) &&
                                          !controller.checkAnswer(
                                            questionNumber,
                                          )) {
                                        controller.markEmpty(soal);
                                      }
                                    },
                                    child: Text(questionNumber.toString()),
                                  ),
                                );
                              }),

                              // Tombol Next
                              IconButton(
                                onPressed: () {
                                  (controller.currentQuestion.value + 1) <
                                          controller.soalList.length
                                      ? controller.currentQuestion.value++
                                      : null;
                                  int questionNumber =
                                      controller.currentPage.value;
                                  if (!controller.checkMark(soal) &&
                                      !controller.checkAnswer(questionNumber)) {
                                    controller.markEmpty(soal);
                                  }
                                },
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  controller.soalList.isEmpty
                      ? Skeletonizer(
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
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
                      )
                      : SizedBox.shrink(),

                  // Ambil soal aktif
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Header soal
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Soal No.${soal['no_soal']}",
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                    icon: Icon(
                                      Icons.flag,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      showLaporSoalModal(
                                        context,
                                        soal,
                                        controller,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Container(
                            margin: EdgeInsets.all(8),
                            child:
                                (soal['soal'] == null ||
                                        soal['soal'].toString().isEmpty)
                                    ? Skeletonizer(
                                      enabled: true,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 18,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                          ),
                                          SizedBox(height: 6),
                                          Container(
                                            height: 18,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                          ),
                                          SizedBox(height: 6),
                                          Container(
                                            height: 18,
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.6,
                                            color: Colors.grey.shade300,
                                          ),
                                        ],
                                      ),
                                    )
                                    : Html(
                                      data: soal['soal'] ?? "",
                                      extensions: [
                                        TagExtension(
                                          tagsToExtend: {
                                            "img",
                                          }, // khusus untuk <img>
                                          builder: (context) {
                                            final src =
                                                context.attributes['src'] ?? '';
                                            return SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Image.network(
                                                src,
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Icon(
                                                      Icons.broken_image,
                                                      color: Colors.red,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                          ),

                          SizedBox(height: 24),

                          // List opsi jawaban
                          Obx(() {
                            final selectedAnswer =
                                controller.selectedAnswers[controller
                                    .currentQuestion
                                    .value];

                            final options = soal['options'] as List? ?? [];

                            if (options.isEmpty) {
                              // tampilkan skeleton kalau data masih kosong
                              return Skeletonizer(
                                enabled: true,
                                child: Column(
                                  children: List.generate(4, (index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            color: Colors.grey.shade300,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Container(
                                              height: 16,
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }

                            // kalau options sudah ada → render ListView biasa
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final option = options[index];
                                return Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 4),
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
                                            style: TextStyle(
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
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

void showLaporSoalModal(
  BuildContext context,
  Map soal,
  PretestController controller,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    context: context,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Laporkan Soal",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(height: 1),
                SizedBox(height: 12),
                Text(
                  "Silahkan isi form di bawah untuk melaporkan soal:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: controller.laporanController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "Isi laporan...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      if (controller.laporanController.text.isEmpty) {
                        notifHelper.show(
                          "Mohon isi laporan terlebih dahulu",
                          type: 0,
                        );
                        return;
                      }

                      controller.sendLaporSoal(
                        questionId: soal['id'],
                        laporan: controller.laporanController.text,
                        context: context,
                      );

                      Navigator.pop(context);
                    },
                    child: Text(
                      "Kirim Laporan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
}
