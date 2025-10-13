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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tombol Sebelumnya
                      ElevatedButton(
                        key: controller.prevKey,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_back_ios, size: 16),
                            SizedBox(width: 4),
                            Text("Sebelumnya", style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Timer
                      Text(
                        "00:00:00",
                        key: controller.timerKey,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Tombol Selanjutnya
                      ElevatedButton(
                        key: controller.nextKey,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Text("Selanjutnya", style: TextStyle(fontSize: 13)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            "Panduan Pretest",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                key: controller.selesaiKey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(183, 57, 213, 213),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Selesai",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Card Nomor Soal
              Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Nomor Soal",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        key: controller.nomorSoalKey,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                            ),
                            onPressed: () {},
                            child: const Text("1"),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Card Soal
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Header Soal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Soal No. 1",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              IconButton(
                                key: controller.tandaiKey,
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.bookmark,
                                  color: Colors.amberAccent,
                                ),
                              ),
                              IconButton(
                                key: controller.flagKey,
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.flag,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Teks Soal
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          key: controller.soalKey,
                          "Sebagai pegawai kantoran, Anda memiliki delapan jam kerja aktif. Di lain sisi, Anda adalah seorang istri dan ibu dari dua balita. Bagaimana Anda mengatur tugas Anda sebagai pegawai dan ibu rumah tangga agar semua berjalan seimbang?",
                          style: const TextStyle(height: 1.4),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // List Opsi
                      ListView.builder(
                        key: controller.optionKey,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.opsi.length,
                        itemBuilder: (context, index) {
                          final inisial = String.fromCharCode(65 + index);
                          final option = controller.opsi[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Card(
                              color: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 28,
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
