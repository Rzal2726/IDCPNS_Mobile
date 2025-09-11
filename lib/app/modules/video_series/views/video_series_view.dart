import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/video_series_controller.dart';

class VideoSeriesView extends GetView<VideoSeriesController> {
  const VideoSeriesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text("Video Series"),
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
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  label: Text("Filter", style: TextStyle(color: Colors.teal)),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
                ),
              ),

              Obx(() {
                if (controller.listVideo.isEmpty) {
                  // Saat data kosong, tampilkan Skeletonizer
                  return Skeletonizer(
                    child: _cardVidio(
                      imgUrl:
                          "https://cms.idcpns.com/storage/upload/video-series/2024-07/d5d2571241b1c69079e3814f01966206.jpg",
                      kategori: "CPNS",
                      kategoriColor: Colors.grey,
                      title: "Materi Lengkap SKD CPNS",
                      duration: "706",
                      totalVid: "55",
                      data: <String, dynamic>{},
                    ),
                  );
                }

                // Saat data ada
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: controller.listVideo.length,
                    itemBuilder: (context, index) {
                      final data = controller.listVideo[index];
                      return _cardVidio(
                        imgUrl: data['gambar'],
                        kategori: data['menu_category']['menu'],
                        kategoriColor: Colors.grey,
                        title: data['nama'],
                        duration: data['total_durasi'].toString(),
                        totalVid: data['video_topics'].length.toString(),
                        data: data,
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardVidio({
    required String imgUrl,
    required String kategori,
    required Color kategoriColor,
    required String title,
    required String duration,
    required String totalVid,
    required Map<String, dynamic> data,
  }) {
    return Card(
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image.network(
                imgUrl, // ganti dengan gambar kamu
                // width: 140,
                // height: 128,
                fit: BoxFit.fill,
                errorBuilder: (
                  BuildContext context,
                  Object exception,
                  StackTrace? stackTrace,
                ) {
                  return Image.asset("assets/logo.png");
                },
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 120,
              child: _badge(isi: kategori, backgroundColor: kategoriColor),
            ),
            SizedBox(height: 16),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("${totalVid} Video"), Text("${duration} Menit")],
            ),
            SizedBox(height: 16),
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
                  Get.toNamed("/watch-video", arguments: data);
                },
                child: Text("Tonton Sekarang"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge({
    required String? isi,
    Color backgroundColor = Colors.grey,
    Color foregroundColor = Colors.white,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Center(
          child: Text(
            isi ?? '',
            style: TextStyle(color: foregroundColor, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
