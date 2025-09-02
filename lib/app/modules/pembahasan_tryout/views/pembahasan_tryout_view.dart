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
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(),
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
                                  return DraggableScrollableSheet(
                                    expand: false,
                                    initialChildSize:
                                        0.7, // 70% tinggi layar saat muncul
                                    minChildSize: 0.4,
                                    maxChildSize: 0.95,
                                    builder: (context, scrollController) {
                                      return Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // drag handle
                                            Center(
                                              child: Container(
                                                width: 40,
                                                height: 4,
                                                margin: const EdgeInsets.only(
                                                  bottom: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              "List Nomor Soal",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
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
                                                        crossAxisCount: 5,
                                                        crossAxisSpacing: 6,
                                                        mainAxisSpacing: 6,
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
                                                    return ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            controller
                                                                        .currentNumber
                                                                        .value ==
                                                                    index
                                                                ? Colors
                                                                    .green
                                                                    .shade100
                                                                : Colors.white,
                                                        foregroundColor:
                                                            Colors.black,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          side: const BorderSide(
                                                            color:
                                                                Colors.black12,
                                                          ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 10,
                                                            ),
                                                        elevation: 0,
                                                      ),
                                                      onPressed: () {
                                                        controller
                                                            .currentNumber
                                                            .value = index;
                                                        Navigator.pop(context);
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
                          height: 320,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(), // biar ga bentrok scroll parent
                            itemCount: data['options'].length,
                            itemBuilder: (context, index) {
                              final optionData =
                                  data['options'][index]; // ambil item
                              return _option(
                                optionData['inisial'],
                                optionData['jawaban'],
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
    );
  }

  Widget _option(String initial, String body, int isCorrect) {
    return Card(
      color: isCorrect == 1 ? Colors.green.shade100 : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isCorrect == 1 ? Colors.green : Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: Text(
                "${initial}. ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
