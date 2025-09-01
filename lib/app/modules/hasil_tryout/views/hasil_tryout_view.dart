import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/hasil_tryout_controller.dart';

class HasilTryoutView extends GetView<HasilTryoutController> {
  const HasilTryoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Hasil Tryout'),
      ),
      body: Container(
        margin: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Terima Kasih Atas Partisipasi Anda",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              "Berikut adalah hasil tryout yang telah Anda kerjakan",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 32),
            Obx(() {
              final tryOutSaya = controller.tryOutSaya;
              final nilaiChart = controller.nilaiChart;

              // Kondisi kalau datanya kosong/null
              if (tryOutSaya.isEmpty || nilaiChart.isEmpty) {
                return Skeletonizer(
                  child: Card(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Hasil",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("TBI"), Text("0/0")],
                          ),
                          SizedBox(height: 32),
                          Divider(color: Colors.grey.shade300),
                          SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Poin",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text("0"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Keterangan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text("-"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              if (nilaiChart['statistics'] == null ||
                  (nilaiChart['statistics'] as List).isEmpty) {
                return Skeletonizer(
                  child: Card(
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Hasil",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("TBI"), Text("0/0")],
                          ),
                          SizedBox(height: 32),
                          Divider(color: Colors.grey.shade300),
                          SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Poin",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text("0"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Keterangan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text("-"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final totalNilai = nilaiChart['total_nilai'] ?? 0;
              final targetNilai = (nilaiChart['statistics']?[0]?['nilai']) ?? 0;
              final isLulus = tryOutSaya['islulus'] == 1;

              return Card(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Hasil",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("TBI"),
                          Row(
                            children: [
                              Text(
                                "$totalNilai",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: isLulus ? Colors.green : Colors.pink,
                                ),
                              ),
                              Text("/"),
                              Text("$targetNilai"),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      Divider(color: Colors.grey.shade300),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Poin",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "$totalNilai",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isLulus ? Colors.green : Colors.pink,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Keterangan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            isLulus ? "Lulus" : "Tidak Lulus",
                            style: TextStyle(
                              color: isLulus ? Colors.green : Colors.pink,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.offNamed(
                    "/detail-tryout-saya",
                    arguments: controller.uuid,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text("Kembali"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
