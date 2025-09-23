import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/pembahasan_tryout_controller.dart';

class PembahasanTryoutView extends GetView<PembahasanTryoutController> {
  const PembahasanTryoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    if (controller.currentNumber.value > 0) {
                      controller.currentNumber.value--;
                    }
                  },
                  child: Row(
                    children: [Icon(Icons.arrow_back_ios), Text("Sebelumnya")],
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
                    if (controller.currentNumber.value <
                        controller.listPembahasan.length - 1) {
                      controller.currentNumber.value++;
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
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text("Pembahasan"),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_rounded, color: Colors.teal),
                    onPressed: () {
                      // ✅ Best practice: use a function for navigation
                      Get.to(() => NotificationView());
                    },
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '4',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: double.infinity),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () =>
                                  controller.listPembahasan.isEmpty
                                      ? Skeletonizer(
                                        child: Text(
                                          "Soal No.",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                      : Text(
                                        "Soal No.${controller.listPembahasan[controller.currentNumber.value]['no_soal'].toString()}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                            ),
                            Row(
                              children: [
                                IconButton(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
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
                                                                    .text ==
                                                                "" ||
                                                            controller
                                                                .laporanController
                                                                .text
                                                                .isEmpty) {
                                                          Get.snackbar(
                                                            "Gagal",
                                                            "Isi laporan terlebih dahulu!",
                                                            backgroundColor:
                                                                Colors.pink,
                                                            colorText:
                                                                Colors.white,
                                                          );

                                                          return;
                                                        }
                                                        controller.sendLaporSoal(
                                                          questionId:
                                                              controller
                                                                  .listPembahasan[controller
                                                                  .currentNumber
                                                                  .value]['id'],
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
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.flag, color: Colors.pink),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.white,
                                      isScrollControlled: true, // <-- penting
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                      ),
                                      builder: (context) {
                                        return SafeArea(
                                          child: DraggableScrollableSheet(
                                            expand: false,
                                            initialChildSize:
                                                0.7, // 70% tinggi layar saat muncul
                                            minChildSize: 0.4,
                                            maxChildSize: 0.95,
                                            builder: (
                                              context,
                                              scrollController,
                                            ) {
                                              return Padding(
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // drag handle
                                                    Center(
                                                      child: Container(
                                                        width: 40,
                                                        height: 4,
                                                        margin:
                                                            const EdgeInsets.all(
                                                              16,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black26,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                2,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Text(
                                                      "List Nomor Soal",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      spacing: 12,
                                                      children: [
                                                        Row(
                                                          spacing: 4,
                                                          children: [
                                                            Icon(
                                                              Icons.circle,
                                                              color:
                                                                  Colors.teal,
                                                            ),
                                                            Text("Benar"),
                                                          ],
                                                        ),
                                                        Row(
                                                          spacing: 4,
                                                          children: [
                                                            Icon(
                                                              Icons.circle,
                                                              color:
                                                                  Colors.pink,
                                                            ),
                                                            Text("Salah"),
                                                          ],
                                                        ),
                                                        Row(
                                                          spacing: 4,
                                                          children: [
                                                            Icon(
                                                              Icons.circle,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            Text("Kosong"),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),

                                                    // isi grid scrollable
                                                    Expanded(
                                                      child: Obx(() {
                                                        if (controller
                                                            .listPembahasan
                                                            .isEmpty) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }

                                                        return GridView.builder(
                                                          controller:
                                                              scrollController, // <-- pakai controller dari Draggable
                                                          gridDelegate:
                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    5,
                                                                crossAxisSpacing:
                                                                    6,
                                                                mainAxisSpacing:
                                                                    6,
                                                                childAspectRatio:
                                                                    1.8, // sesuaikan biar tombolnya pas
                                                              ),
                                                          itemCount:
                                                              controller
                                                                  .listPembahasan
                                                                  .length,
                                                          itemBuilder: (
                                                            context,
                                                            index,
                                                          ) {
                                                            final item =
                                                                controller
                                                                    .listPembahasan[index];
                                                            bool
                                                            hasTransaction =
                                                                item['options'].any(
                                                                  (option) =>
                                                                      option['transaction'] !=
                                                                      null,
                                                                );
                                                            final options =
                                                                item['options']
                                                                    as List;

                                                            // Cari jawaban yang dipilih (punya transaction)
                                                            final selectedOption =
                                                                options.firstWhere(
                                                                  (option) =>
                                                                      option['transaction'] !=
                                                                      null,
                                                                  orElse:
                                                                      () =>
                                                                          null,
                                                                );
                                                            return ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    hasTransaction
                                                                        ? selectedOption['iscorrect'] ==
                                                                                1
                                                                            ? Colors.teal.shade100
                                                                            : Colors.pink.shade100
                                                                        : Colors
                                                                            .grey,
                                                                foregroundColor:
                                                                    Colors
                                                                        .black,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ),
                                                                  side: BorderSide(
                                                                    width:
                                                                        controller.currentNumber.value ==
                                                                                index
                                                                            ? 4
                                                                            : 1,
                                                                    color:
                                                                        controller.currentNumber.value ==
                                                                                index
                                                                            ? Colors.amber
                                                                            : Colors.transparent,
                                                                  ),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          10,
                                                                    ),
                                                                elevation: 0,
                                                              ),
                                                              onPressed: () {
                                                                controller
                                                                    .currentNumber
                                                                    .value = index;
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              child: Text(
                                                                item['no_soal']
                                                                    .toString(),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.list,
                                    color: Colors.teal, // warna tombol,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //Soal
                        Obx(
                          () =>
                              controller.listPembahasan.isEmpty
                                  ? Skeletonizer(
                                    child: Text(
                                      "<p>Adelaide adalah nama sebuah tempat, sehingga <i>pronoun</i> yang digunakan dapat menggunakan <i>where</i>.</p>",
                                    ),
                                  )
                                  : Html(
                                    data:
                                        controller.listPembahasan[controller
                                            .currentNumber
                                            .value]['soal'],
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
                                                  ) => const Icon(
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

                        Obx(() {
                          if (controller.listPembahasan.isEmpty) {
                            return Skeletonizer(
                              child: Text(
                                "<p>Adelaide adalah nama sebuah tempat, sehingga <i>pronoun</i> yang digunakan dapat menggunakan <i>where</i>.</p>",
                              ),
                            );
                          }
                          final data =
                              controller.listPembahasan[controller
                                  .currentNumber
                                  .value];
                          return SizedBox(
                            width: double.infinity,
                            child: ListView.builder(
                              shrinkWrap:
                                  true, // <- penting agar ukuran mengikuti konten
                              physics:
                                  const NeverScrollableScrollPhysics(), // biar ga bentrok scroll parent
                              itemCount: data['options'].length,
                              itemBuilder: (context, index) {
                                final optionData = data['options'][index];
                                return _option(
                                  optionData['inisial'],
                                  optionData['jawaban'],
                                  optionData['iscorrect'],
                                  optionData['transaction'],
                                );
                              },
                            ),
                          );
                        }),
                        SizedBox(height: 16),
                        Text(
                          "Pembahasan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        //Pembahasan
                        Obx(
                          () =>
                              controller.listPembahasan.isEmpty
                                  ? Skeletonizer(
                                    child: Text(
                                      "<p>Adelaide adalah nama sebuah tempat, sehingga <i>pronoun</i> yang digunakan dapat menggunakan <i>where</i>.</p>",
                                    ),
                                  )
                                  : Html(
                                    data:
                                        controller.listPembahasan[controller
                                            .currentNumber
                                            .value]['pembahasan'],
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
                                                  ) => const Icon(
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
                        Text(
                          "Bobot Opsi Jawaban",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Obx(() {
                          if (controller.listPembahasan.isEmpty) {
                            return Skeletonizer(
                              child: Text(
                                "<p>Adelaide adalah nama sebuah tempat, sehingga <i>pronoun</i> yang digunakan dapat menggunakan <i>where</i>.</p>",
                              ),
                            );
                          }
                          final data =
                              controller.listPembahasan[controller
                                  .currentNumber
                                  .value];
                          return SizedBox(
                            width: double.infinity,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // biar ga bentrok scroll parent
                              itemCount: data['options'].length,
                              itemBuilder: (context, index) {
                                final optionData =
                                    data['options'][index]; // ambil item
                                return _optionPembahasan(
                                  optionData['inisial'],
                                  optionData['nilai'].toString(),
                                  optionData['iscorrect'],
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _option(
    String initial,
    String body,
    int isCorrect,
    dynamic transaction,
  ) {
    return Card(
      color:
          transaction != null
              ? isCorrect != 1
                  ? Colors.pink.shade100
                  : isCorrect == 1
                  ? Colors.teal.shade100
                  : Colors.white
              : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isCorrect == 1 ? Colors.teal : Colors.pink),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              height: 32,
              alignment: Alignment.center,
              child: Row(
                spacing: 8,
                children: [
                  Icon(
                    isCorrect == 1 ? Icons.check_circle : Icons.close_rounded,
                    color: isCorrect == 1 ? Colors.teal : Colors.pink,
                  ),
                  Text(
                    "${initial}. ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Html(
                data: body,
                style: {
                  "p": Style(
                    margin: Margins.all(0),
                    padding: HtmlPaddings.all(0),
                    fontSize: FontSize(14),
                    lineHeight: LineHeight.number(1.3),
                  ),
                },
                extensions: [
                  TagExtension(
                    tagsToExtend: {"img"}, // khusus untuk <img>
                    builder: (context) {
                      final src = context.attributes['src'] ?? '';
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Image.network(
                          src,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
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
          ],
        ),
      ),
    );
  }

  Widget _optionPembahasan(String initial, String bobot, int isCorrect) {
    return Card(
      color: isCorrect == 1 ? Colors.teal : Colors.grey,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isCorrect == 1 ? Colors.teal : Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Opsi ${initial}: ${bobot}",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
