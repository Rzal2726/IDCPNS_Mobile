import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/modules/bimbelRicord/controllers/bimbel_ricord_controller.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BimbelRecordView extends GetView<BimbelRecordController> {
  const BimbelRecordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: basicAppBarWithoutNotif("Rekaman"),
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
                            child: InAppWebView(
                              key: ValueKey(
                                video['url'],
                              ), // 👈 ini yang bikin widget "reset"
                              initialUrlRequest: URLRequest(
                                url: WebUri(
                                  "https://www.youtube.com/embed/${YoutubePlayer.convertUrlToId(video['url'] ?? '')}?autoplay=1&modestbranding=1&rel=0",
                                ),
                                headers: {
                                  "Referer": refererUrl,
                                  "User-Agent":
                                      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36",
                                },
                              ),
                              onLoadError: (controller, url, code, message) {
                                debugPrint("Gagal load video: $message");
                              },
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
                    child:
                        controller.rekamanList.isEmpty
                            ? Skeletonizer(
                              child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 16,
                                          width: 120,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 14,
                                              width: 50,
                                              color: Colors.white,
                                            ),
                                            Container(
                                              height: 14,
                                              width: 70,
                                              color: Colors.white,
                                            ),
                                            Container(
                                              height: 14,
                                              width: 40,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Container(
                                          height: 40,
                                          width: double.infinity,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                            : ListView.builder(
                              itemCount: controller.rekamanList.length,
                              itemBuilder: (context, index) {
                                final item = controller.rekamanList[index];
                                final jadwal = item['jadwal_tanggal'] ?? {};
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(jadwal['hari'] ?? '-'),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Tanggal",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(jadwal['tanggal'] ?? '-'),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Jam",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
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
                                          minimumSize: Size(
                                            double.infinity,
                                            40,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed:
                                            (item['url'] != null &&
                                                    DateTime.tryParse(
                                                          item['tanggal'],
                                                        ) !=
                                                        null &&
                                                    (DateTime.parse(
                                                          item['tanggal'],
                                                        ).isBefore(
                                                          DateTime.now(),
                                                        ) ||
                                                        DateTime.parse(
                                                          item['tanggal'],
                                                        ).isAtSameMomentAs(
                                                          DateTime.now(),
                                                        )))
                                                ? () =>
                                                    controller.tontonVideo(item)
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
                                      SizedBox(height: 12),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          minimumSize: Size(
                                            double.infinity,
                                            40,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed:
                                            (item['attachments'] != null &&
                                                    item['attachments']
                                                        .isNotEmpty &&
                                                    DateTime.tryParse(
                                                          item['tanggal'],
                                                        ) !=
                                                        null &&
                                                    (DateTime.parse(
                                                          item['tanggal'],
                                                        ).isBefore(
                                                          DateTime.now(),
                                                        ) ||
                                                        DateTime.parse(
                                                          item['tanggal'],
                                                        ).isAtSameMomentAs(
                                                          DateTime.now(),
                                                        )))
                                                ? () async {
                                                  final url =
                                                      item['attachments'][0]['attachment'];
                                                  if (url != null &&
                                                      url
                                                          .toString()
                                                          .isNotEmpty) {
                                                    final uri = Uri.tryParse(
                                                      url,
                                                    );
                                                    if (uri != null &&
                                                        await canLaunchUrl(
                                                          uri,
                                                        )) {
                                                      await launchUrl(
                                                        uri,
                                                        mode:
                                                            LaunchMode
                                                                .externalApplication,
                                                      );
                                                    } else {
                                                      notifHelper.show(
                                                        "Tidak bisa membuka URL",
                                                        type: 0,
                                                      );
                                                    }
                                                  }
                                                }
                                                : null,

                                        icon: Icon(
                                          Icons.file_copy,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          "Download lampiran",
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
