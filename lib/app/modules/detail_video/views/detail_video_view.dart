import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controllers/detail_video_controller.dart';

class DetailVideoView extends GetView<DetailVideoController> {
  const DetailVideoView({super.key});
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
            title: Text("Detail Video"),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_rounded, color: Colors.teal),
                    onPressed: () {
                      // ✅ Best practice: use a function for navigation
                      Get.to(() => NotificationView());
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
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          if (!controller.isReady.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (controller.videoData['isyoutube'] == 1) {
                              return YoutubePlayerBuilder(
                                player: YoutubePlayer(
                                  controller: controller.ytController,
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor: Colors.amber,
                                  progressColors: const ProgressBarColors(
                                    playedColor: Colors.amber,
                                    handleColor: Colors.amberAccent,
                                  ),
                                  onReady: () {
                                    debugPrint('Player is ready.');
                                  },
                                ),
                                builder: (context, player) {
                                  return Column(
                                    children: [
                                      // ✅ Player otomatis fullscreen jika user klik tombol fullscreen
                                      player,

                                      const SizedBox(height: 12),

                                      Text(
                                        "Pengantar (Kisi - Kisi dan Passing Grade)",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              return SizedBox(
                                width: double.infinity,
                                height: 240,
                                child: WebViewWidget(
                                  controller: controller.webViewController,
                                ),
                              );
                            }
                          }
                        }),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () {},
                              label: Text("Sebelumnya"),
                              icon: Icon(Icons.arrow_back_ios_outlined),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                              ),
                              iconAlignment: IconAlignment.end,
                              onPressed: () {},
                              label: Text("Selanjutnya"),
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                            ),
                          ],
                        ),

                        Obx(() {
                          if (!controller.isReady.value) {
                            return Skeletonizer(child: Text("data"));
                          }
                          return SizedBox(
                            width: 100,
                            child: _badge(
                              title:
                                  controller
                                      .videoData['video_series']['menu_category']?['menu'] ??
                                  "",
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  controller.categoryColor[controller
                                      .videoData['video_series']['menu_category']?['menu']]!,
                            ),
                          );
                        }),
                        Obx(() {
                          if (!controller.isReady.value) {
                            return Skeletonizer(child: Text("data"));
                          }
                          return Text(
                            controller.videoData['nama'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Card(
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:
                                controller.option.map((option) {
                                  final isSelected =
                                      controller.selectedOption.value == option;
                                  return GestureDetector(
                                    onTap:
                                        () =>
                                            controller.selectedOption.value =
                                                option,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            option,
                                            style: TextStyle(
                                              color:
                                                  isSelected
                                                      ? Colors.teal
                                                      : Colors.grey[700],
                                              fontWeight:
                                                  isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 200,
                                            ),
                                            height: 2,
                                            width: isSelected ? 20 : 0,
                                            color: Colors.teal,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          );
                        }),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        Obx(() {
                          if (controller.isReady.value == false) {
                            return Skeletonizer(child: Text("data"));
                          }
                          switch (controller.selectedOption.value) {
                            case "QnA":
                              return Column(
                                children: [
                                  TextField(
                                    controller: controller.questionController,
                                    maxLines: 6,
                                    decoration: InputDecoration(
                                      hintText: "Tulis pertanyaanmu disini",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.all(12),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        "Kirim",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  ListView.builder(
                                    shrinkWrap:
                                        true, // ✅ Agar tinggi otomatis menyesuaikan
                                    physics:
                                        const NeverScrollableScrollPhysics(), // ✅ Scroll dihandle parent
                                    itemCount: controller.commentList.length,
                                    itemBuilder: (context, index) {
                                      final data =
                                          controller.commentList[index];
                                      return _commentData(
                                        data: data,
                                        isReply:
                                            (data['comment_reply'] as List?)
                                                ?.isNotEmpty ??
                                            false,
                                      );
                                    },
                                  ),
                                ],
                              );
                            default:
                              return Column(
                                children: [
                                  Obx(
                                    () => TextField(
                                      controller: controller.questionController,
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText:
                                            "Buat Catatan pada durasi ${controller.duration.value}",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.all(
                                          12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        "Buat",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge({
    required String title,
    required Color foregroundColor,
    required Color backgroundColor,
  }) {
    return Card(
      color: backgroundColor,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Center(
          child: Text(title, style: TextStyle(color: foregroundColor)),
        ),
      ),
    );
  }

  Widget _commentData({
    required Map<String, dynamic> data,
    bool isReply = false,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: isReply ? 32 : 0,
        bottom: 16,
      ), // indent untuk balasan
      padding: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto & Nama User
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(data['user']?['foto'] ?? ''),
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['user']?['name'] ?? "User",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      controller.timeAgo(data['tanggal']),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Isi komentar
          Text(data['comment'] ?? '', style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),

          // Aksi Balas dan Lihat Balasan
          Row(
            spacing: 16,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  // TODO: implementasi fitur balas komentar
                },
                child: const Text(
                  "Balas",
                  style: TextStyle(color: Colors.teal),
                ),
              ),
              if ((data['comment_reply'] as List?)?.isNotEmpty ?? false)
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    // TODO: Toggle expand reply
                  },
                  child: const Text(
                    "Lihat Balasan",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
            ],
          ),

          // List balasan komentar
          if ((data['comment_reply'] as List?)?.isNotEmpty ?? false)
            Column(
              children:
                  (data['comment_reply'] as List)
                      .map(
                        (reply) => _commentData(
                          data: reply as Map<String, dynamic>,
                          isReply: true,
                        ),
                      )
                      .toList(),
            ),
        ],
      ),
    );
  }
}
