import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/platinum_zone_controller.dart';

class PlatinumZoneView extends GetView<PlatinumZoneController> {
  PlatinumZoneView({super.key});
  final controller = Get.put(PlatinumZoneController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(32),
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: double.infinity, child: _expireCard()),
              SizedBox(
                width: double.infinity,
                child: _menuCard(
                  imageurl: "assets/video_series.png",
                  title: "Video Series",
                  routeName: "/video-series",
                  bgColor: Color.fromARGB(255, 255, 222, 211),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: _menuCard(
                  imageurl: "assets/ebook.png",
                  title: "E-Book",
                  routeName: "/e-book",
                  bgColor: Color.fromARGB(255, 255, 182, 246),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: _menuCard(
                  imageurl: "assets/tryout_harian.png",
                  title: "Tryout Harian",
                  routeName: "/tryout-harian",
                  bgColor: Color.fromARGB(255, 177, 220, 255),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: _menuCard(
                  imageurl: "assets/webinar.png",
                  title: "Webinar",
                  routeName: "/webinar",
                  bgColor: Color.fromARGB(255, 205, 255, 236),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _expireCard() {
    return Card(
      color: Colors.yellow.shade100,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Member Platinum Sampai Dengan"),
            Obx(() {
              if (controller.data.isEmpty) {
                return Skeletonizer(
                  child: Text("Member Platinum Sampai Dengan"),
                );
              }
              return Text(
                controller.data['level_expired_at'] == null
                    ? "Invalid Date"
                    : controller.data['level_expired_at'].toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required String imageurl,
    required String title,
    required String routeName,
    required Color bgColor,
  }) {
    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias, // biar image ikut rounded
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background image
          Image.asset(
            imageurl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 180,
          ),

          // Overlay biar teks lebih jelas
          Container(
            width: double.infinity,
            height: 180,
            color: Colors.black.withOpacity(0.3),
          ),

          // Konten rata kiri tapi vertical center
          Container(
            margin: const EdgeInsets.all(16), // biar ada jarak dari pinggir
            child: Column(
              mainAxisSize: MainAxisSize.min, // biar ngepas kontennya
              crossAxisAlignment: CrossAxisAlignment.center, // rata kiri
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed(routeName);
                  },
                  child: const Text(
                    "Lihat",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
