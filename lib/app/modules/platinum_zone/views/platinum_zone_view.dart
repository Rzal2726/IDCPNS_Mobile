import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import '../controllers/platinum_zone_controller.dart';

class PlatinumZoneView extends GetView<PlatinumZoneController> {
  PlatinumZoneView({super.key});
  final controller = Get.put(PlatinumZoneController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: basicAppBar(),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => controller.init(),
        child: Obx(() {
          if (controller.loading.value) {
            return Skeletonizer(
              child: Container(
                margin: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: double.infinity, child: _expireCard()),
                    const SizedBox(height: 16),
                    _menuCard(
                      imageurl: "assets/video_series.png",
                      title: "Video Series",
                      routeName: "/video-series",
                      bgColor: const Color.fromARGB(255, 255, 222, 211),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              // Menu utama yang bisa di-scroll
              IgnorePointer(
                ignoring: controller.userData['level_name'] == "Basic",
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    SizedBox(width: double.infinity, child: _expireCard()),
                    _menuCard(
                      imageurl: "assets/video_series.png",
                      title: "Video Series",
                      routeName: "/video-series",
                      bgColor: const Color.fromARGB(255, 255, 222, 211),
                    ),
                    _menuCard(
                      imageurl: "assets/ebook.png",
                      title: "E-Book",
                      routeName: "/e-book",
                      bgColor: const Color.fromARGB(255, 255, 182, 246),
                    ),
                    _menuCard(
                      imageurl: "assets/tryout_harian.png",
                      title: "Tryout Harian",
                      routeName: "/tryout-harian",
                      bgColor: const Color.fromARGB(255, 177, 220, 255),
                    ),
                    _menuCard(
                      imageurl: "assets/webinar.png",
                      title: "Webinar",
                      routeName: "/webinar",
                      bgColor: const Color.fromARGB(255, 205, 255, 236),
                    ),
                  ],
                ),
              ),

              // Overlay untuk user Basic
              if (controller.userData['level_name'] == "Basic")
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Upgrade akun untuk mengakses platinum zone",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {
                              Get.toNamed('/upgrade-akun');
                            },
                            child: const Text(
                              "Upgrade Akun",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _expireCard() {
    return InkWell(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        color: Colors.yellow.shade100,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Member Platinum Sampai Dengan"),
              Obx(() {
                if (controller.data.isEmpty) {
                  return const Skeletonizer(
                    child: Text("Member Platinum Sampai Dengan"),
                  );
                }
                return Text(
                  controller.data['level_expired_at'] == null
                      ? "Invalid Date"
                      : DateFormat("d/M/y")
                          .format(
                            DateTime.parse(controller.data['level_expired_at']),
                          )
                          .toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
        margin: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias, // biar rounded mengikuti shape
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bagian Kiri -> Title dan Tombol
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

              // Bagian Kanan -> Gambar ilustrasi
              Image.asset(imageurl, height: 120, fit: BoxFit.cover),
            ],
          ),
        ),
      ),
    );
  }
}
