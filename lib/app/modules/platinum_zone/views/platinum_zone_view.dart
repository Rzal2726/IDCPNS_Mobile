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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Image.asset(
          'assets/logo.png', // Dummy logo
          height: 55,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none, color: Colors.teal),
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
    return InkWell(
      child: Card(
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
      ),
    );
  }

  Widget _menuCard({
    required String imageurl,
    required String title,
    required String routeName,
    required Color bgColor,
  }) {
    return InkWell(
      onTap: () {
        Get.toNamed(routeName);
      },
      child: Card(
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias, // biar rounded mengikuti shape
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              /// Bagian Kiri -> Title dan Tombol
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () {
                      Get.toNamed(routeName);
                    },
                    child: const Text(
                      "Lihat",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              /// Bagian Kanan -> Gambar ilustrasi
              Image.asset(imageurl, height: 120, fit: BoxFit.cover),
            ],
          ),
        ),
      ),
    );
  }
}
