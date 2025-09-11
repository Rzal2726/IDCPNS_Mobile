import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/bimbelRicord/controllers/bimbel_ricord_controller.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BimbelRecordView extends GetView<BimbelRecordController> {
  const BimbelRecordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Rekaman", style: AppStyle.appBarTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppStyle.screenPadding,
          child: Obx(() {
            final video = controller.selectedVideo;
            final list = controller.rekamanList;

            return Container(
              padding: AppStyle.contentPadding,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rekaman Bimbel",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  // Player hanya muncul kalau ada video terpilih
                  if (video.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: YoutubePlayer(
                              controller: YoutubePlayerController(
                                initialVideoId:
                                    YoutubePlayer.convertUrlToId(
                                      video['url'] ?? '',
                                    )!,
                                flags: YoutubePlayerFlags(autoPlay: true),
                              ),
                              showVideoProgressIndicator: true,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  video['judul'] ?? '',
                                  style: TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: controller.closeVideo,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  // List Video
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        final jadwal = item['jadwal_tanggal'] ?? {};

                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['judul'] ?? '-',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Hari",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(jadwal['hari'] ?? '-'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Tanggal",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(jadwal['tanggal'] ?? '-'),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Jam",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(jadwal['jam'] ?? '-'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  minimumSize: Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed:
                                    item['url'] != null
                                        ? () => controller.tontonVideo(item)
                                        : null,
                                icon: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Tonton",
                                  style: TextStyle(color: Colors.white),
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
            );
          }),
        ),
      ),
    );
  }
}
