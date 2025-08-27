import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
                    backgroundColor: const Color.fromARGB(
                      183,
                      57,
                      213,
                      213,
                    ), // warna tombol
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
                    Get.offAllNamed("home");
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
                  onPressed: () {},
                  child: Row(
                    children: [Icon(Icons.arrow_back_ios), Text("Sebelumnya")],
                  ),
                ),
                Text("00:00:00"),
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
                  onPressed: () {},
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
                                  return SingleChildScrollView(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      spacing: 8,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "List Nomor Soal",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: 10,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    5, // jumlah kolom
                                                crossAxisSpacing: 4,
                                                mainAxisSpacing: 4,
                                              ),
                                          itemBuilder: (context, index) {
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor:
                                                    Colors
                                                        .black, // warna teks/icon
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12,
                                                    ),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                (index + 1).toString(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.list,
                              color: Color.fromARGB(
                                183,
                                57,
                                213,
                                213,
                              ), // warna tombol,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Tombol Back
                          IconButton(
                            onPressed:
                                controller.currentPage.value > 0
                                    ? () {
                                      controller.currentPage.value--;
                                    }
                                    : null, // disable kalau di page pertama
                            icon: const Icon(Icons.arrow_back_ios),
                          ),

                          // Tombol nomor soal fixed
                          ...List.generate(controller.numberPerPage.value, (
                            index,
                          ) {
                            int questionNumber =
                                controller.currentPage.value *
                                    controller.numberPerPage.value +
                                (index + 1);

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 4,
                                  ),
                                ),
                                onPressed: () {
                                  // logika pilih soal
                                  // controller.goToQuestion(questionNumber);
                                },
                                child: Text(questionNumber.toString()),
                              ),
                            );
                          }),

                          // Tombol Next
                          IconButton(
                            onPressed:
                                (controller.currentPage.value + 1) *
                                            controller.numberPerPage.value <
                                        controller.soalList.length
                                    ? () {
                                      controller.currentPage.value++;
                                    }
                                    : null, // disable kalau sudah di page terakhir
                            icon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Card(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Soal No.1",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
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
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          "Soal ini berisi Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        ),
                      ),

                      SizedBox(height: 24),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.optionList[0].length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: double.infinity,
                            child: ChoiceChip(
                              label: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Opsi ${controller.optionList[0][(index + 1).toString()]}",
                                  style: TextStyle(),
                                ),
                              ),
                              selected: false,
                              selectedColor: Colors.teal.withOpacity(0.1),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              onSelected: (value) {},
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
