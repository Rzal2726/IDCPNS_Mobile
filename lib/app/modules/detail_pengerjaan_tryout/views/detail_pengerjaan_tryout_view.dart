import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/detail_pengerjaan_tryout_controller.dart';

class DetailPengerjaanTryoutView
    extends GetView<DetailPengerjaanTryoutController> {
  const DetailPengerjaanTryoutView({super.key});

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
              IconButton(
                icon: Icon(Icons.notifications_rounded, color: Colors.teal),
                onPressed: () {
                  Get.to(NotificationView());
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
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(12),
              child: Card(
                color: Colors.white,
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Obx(() {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Text(
                          "Pengerjaan Tryout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        controller.tryOutSaya.isEmpty
                            ? Skeletonizer(
                              child: Text(
                                "Judul Tryout",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            )
                            : Text(
                              controller.tryOutSaya['tryout']['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Jumlah Soal"),
                            controller.tryOutSaya.isEmpty
                                ? Skeletonizer(
                                  child: Text(
                                    "Judul Tryout",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                                : Text(
                                  "${controller.tryOutSaya['tryout']['jumlah_soal'].toString()} Soal",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Durasi tryout"),
                            controller.tryOutSaya.isEmpty
                                ? Skeletonizer(
                                  child: Text(
                                    "Judul Tryout",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                                : Text(
                                  "${controller.tryOutSaya['tryout']['waktu_pengerjaan'].toString()} Menit",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              Get.offAllNamed(
                                "/pengerjaan-tryout",
                                arguments: controller.prevController.uuid.value,
                              );
                            },
                            child: Text("Mulai Tryout"),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.teal,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              Get.toNamed("panduan-tryout");
                            },
                            child: Text("Panduan"),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(12),
              child: Card(
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Peraturan Tryout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Obx(
                        () => ListView.builder(
                          itemCount: controller.instructions.length,
                          shrinkWrap: true, // ✅ penting
                          physics:
                              NeverScrollableScrollPhysics(), // ✅ biar ikut scroll parent
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${index + 1}. ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      controller.instructions[index],
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
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
