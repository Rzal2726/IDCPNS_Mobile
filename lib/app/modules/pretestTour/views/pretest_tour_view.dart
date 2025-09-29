import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/pretest_tour_controller.dart';

class PretestTourView extends GetView<PretestTourController> {
  const PretestTourView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initTargets();
      if (controller.targets.isNotEmpty) {
        controller.showTutorial(context);
      }
    });
    return PopScope(
      canPop: false, // ⛔ blokir tombol back
      onPopInvoked: (didPop) {
        // didPop = true kalau udah berhasil pop
        // karena kita set canPop: false, ini nggak bakal dipanggil kecuali kamu ubah canPop: true
      },
      child: Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    key: controller.prevKey,
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
                        Icon(Icons.arrow_back_ios),
                        Text("Sebelumnya"),
                      ],
                    ),
                  ),
                  Text(key: controller.timerKey, "00:00:00"),
                  ElevatedButton(
                    key: controller.nextKey,
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text("Panduan pretest"),
          actions: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  child: ElevatedButton(
                    key: controller.selesaiKey,
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
                    onPressed: () {},
                    child: Text("Selesai"),
                  ),
                ),
              ],
            ),
          ],
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
                        child: Text(
                          "Nomor Soal",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        key: controller.nomorSoalKey,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_back_ios),
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
                            onPressed: () {},
                            child: Text("1"),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
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
                                key: controller.tandaiKey,
                                onPressed: () {},
                                icon: Icon(
                                  Icons.bookmark,
                                  color: Colors.amberAccent,
                                ),
                              ),
                              IconButton(
                                key: controller.flagKey,
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
                          "Sebagai pegawai kantoran, Anda memiliki delapan jam kerja aktif. Di lain sisi, Anda adalah seorang istri dan ibu dari dua balita. Bagaimana Anda mengatur tugas Anda sebagai pegawai dan ibu rumah tangga agar semua berjalan seimbang?",
                          key: controller.soalKey,
                        ),
                      ),

                      SizedBox(height: 24),

                      ListView.builder(
                        key: controller.optionKey,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.opsi.length,
                        itemBuilder: (context, index) {
                          final inisial = String.fromCharCode(
                            65 + index,
                          ); // A, B, C, D, E
                          final option = controller.opsi[index];

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
                            child: ListTile(
                              leading: Icon(
                                Icons.radio_button_unchecked,
                                color: Colors.grey,
                              ),
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 32,
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "$inisial.",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
}
