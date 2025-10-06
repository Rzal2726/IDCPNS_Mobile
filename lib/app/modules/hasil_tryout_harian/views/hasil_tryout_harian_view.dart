import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/hasil_tryout_harian_controller.dart';

class HasilTryoutHarianView extends GetView<HasilTryoutHarianController> {
  const HasilTryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar(
        "Kategori",
        onBack: () {
          Get.offAllNamed("/tryout-harian");
        },
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/trophy-78dfa836.svg", width: 160),
              const Text(
                "Selamat Pejuang!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 4),
              const Text(
                "Berikut nilai yang kamu dapatkan dari sesi tryout ini",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 32),

              /// === OBSERVER ===
              Obx(() {
                final nilaiChart = controller.nilaiChart;

                // Loading state
                if (nilaiChart.isEmpty) {
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

                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Jawaban Benar",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${nilaiChart['total_benar'].toString()}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Tambahan Poin",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${nilaiChart['total_point'].toString()}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
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
                              "${nilaiChart['total_user_point'].toString()}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
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
                    Get.offNamed("/tryout-harian", arguments: controller.uuid);
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
