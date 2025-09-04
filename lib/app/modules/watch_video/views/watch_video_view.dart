import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/watch_video_controller.dart';

class WatchVideoView extends GetView<WatchVideoController> {
  const WatchVideoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Tonton Video"),
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
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              Obx(() {
                if (controller.loading['video'] == true) {
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
                } else {
                  if (controller.listVideo.isEmpty) {
                    return Center(child: Text("Unavailable"));
                  } else {
                    return _cardVidio(
                      imgUrl: controller.prevData['gambar'],
                      kategori: controller.prevData['menu_category']['menu'],
                      kategoriColor: Colors.grey,
                      title: controller.prevData['nama'],
                      duration: controller.prevData['total_durasi'].toString(),
                      totalVid:
                          controller.prevData['video_topics'].length.toString(),
                      data: <String, dynamic>{},
                    );
                  }
                }
              }),
              Expanded(
                child: Obx(() {
                  if (controller.loading['video'] == true) {
                    Skeletonizer(
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

                  if (controller.listVideo.isEmpty) {
                    return Center(child: Text("Unavailable"));
                  }
                  return ListView.builder(
                    itemCount: controller.listVideo.length,
                    itemBuilder: (context, index) {
                      final section = controller.listVideo[index];
                      final videos = section['topics'] as List;

                      return Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: ExpansionTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.transparent),
                          ),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text(
                            section['nama'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_down),
                          children: [
                            ListView.builder(
                              physics:
                                  const NeverScrollableScrollPhysics(), // biar nggak conflict scroll
                              shrinkWrap: true, // wajib untuk nested list
                              itemCount: videos.length,
                              itemBuilder: (context, vidIndex) {
                                final video = videos[vidIndex];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 0,
                                  ),
                                  leading: Checkbox(
                                    value:
                                        video['video_completed'].isEmpty
                                            ? false
                                            : true, // nanti bisa diubah ke RxBool
                                    onChanged: (val) {},
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  title: Text(
                                    video['nama'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    video['durasi'].toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.teal,
                                    ),
                                    onPressed: () {
                                      // Aksi play video
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
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
            SizedBox(height: 48),
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
