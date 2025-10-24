import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/getOffNamedUntil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/hasil_tryout_controller.dart';

class HasilTryoutView extends GetView<HasilTryoutController> {
  const HasilTryoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // <- biar kita kontrol manual
      onPopInvoked: (didPop) {
        if (!didPop) {
          Get.offAllNamed("/detail-tryout-saya", arguments: controller.uuid);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Hasil Tryout'),
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Terima Kasih Atas Partisipasi Anda",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Berikut adalah hasil tryout yang telah Anda kerjakan",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 32),

                /// === OBSERVER ===
                Obx(() {
                  final tryOutSaya = controller.tryOutSaya;
                  final nilaiChart = controller.nilaiChart;

                  // Loading state
                  if (tryOutSaya.isEmpty || nilaiChart.isEmpty) {
                    return Skeletonizer(child: _buildSkeletonCard());
                  }

                  final List<dynamic> statistics =
                      nilaiChart['statistics'] ?? [];
                  final totalNilai = nilaiChart['total_nilai'] ?? 0;
                  final totalNilaiSempurna =
                      nilaiChart['total_nilai_sempurna'] ?? 0;
                  final isLulus = tryOutSaya['islulus'] == 1;

                  if (statistics.isEmpty) {
                    return Skeletonizer(child: _buildSkeletonCard());
                  }

                  return Card(
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hasil",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),

                          /// === LIST DARI API ===
                          Column(
                            children:
                                statistics.map((stat) {
                                  final title = stat['title'] ?? '-';
                                  final resultNilai =
                                      stat['result_nilai'] ?? '0';
                                  final nilai = stat['nilai'] ?? 0;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "$resultNilai",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color:
                                                    int.parse(
                                                              resultNilai
                                                                  .toString(),
                                                            ) >
                                                            int.parse(
                                                              nilai.toString(),
                                                            )
                                                        ? Colors.green
                                                        : Colors.pink,
                                              ),
                                            ),
                                            const Text("/"),
                                            Text("$nilai"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),

                          const SizedBox(height: 24),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 24),

                          /// === TOTAL NILAI ===
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Poin",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "$totalNilai/$totalNilaiSempurna",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isLulus ? Colors.green : Colors.pink,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          /// === KETERANGAN ===
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Keterangan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                isLulus ? "Lulus" : "Tidak Lulus",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
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

                const SizedBox(height: 20),

                /// === BUTTON KEMBALI ===
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      offNamedUntilAny('/detail-tryout-saya', {
                        '/dashboard',
                        '/tryout',
                        '/tryout-saya',
                        '/detail-event-tryout',
                      }, arguments: controller.uuid);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Kembali"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Skeleton untuk loading state
  Widget _buildSkeletonCard() {
    return Card(
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Row(
              children: const [
                Text(
                  "Hasil",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text("TBI"), Text("0/0")],
            ),
            const SizedBox(height: 32),
            Divider(color: Colors.grey),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Total Poin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text("0"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Keterangan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text("-"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
