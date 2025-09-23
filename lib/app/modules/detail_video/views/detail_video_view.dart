import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:rich_editor/rich_editor.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controllers/detail_video_controller.dart';

class DetailVideoView extends GetView<DetailVideoController> {
  const DetailVideoView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // <- biar kita kontrol manual
      onPopInvoked: (didPop) {
        if (!didPop) {
          Get.back(result: "refresh");
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:
            MediaQuery.of(context).orientation == Orientation.landscape
                ? null
                : PreferredSize(
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
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Get.back(result: "refresh");
                        },
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      title: Text("Detail Video"),
                      actions: [
                        Stack(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.notifications_rounded,
                                color: Colors.teal,
                              ),
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
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
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
                                    progressIndicatorColor: Colors.teal,
                                    progressColors: ProgressBarColors(
                                      playedColor: Colors.teal,
                                      handleColor: Colors.teal.shade400,
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
                              Obx(
                                () => ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        controller.prevTopic.value == ""
                                            ? Colors.grey.shade200
                                            : Colors.white,
                                  ),
                                  onPressed: () {
                                    controller.goToPrevTopic();
                                  },
                                  label: Text(
                                    "Sebelumnya",
                                    style: TextStyle(
                                      color:
                                          controller.prevTopic.value == ""
                                              ? Colors.grey
                                              : Colors.black,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color:
                                        controller.prevTopic.value == ""
                                            ? Colors.grey
                                            : Colors.black,
                                  ),
                                ),
                              ),
                              Obx(
                                () => ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        controller.nextTopic.value == ""
                                            ? Colors.grey.shade200
                                            : Colors.white,
                                  ),
                                  iconAlignment: IconAlignment.end,
                                  onPressed: () {
                                    controller.goToNextTopic();
                                  },
                                  label: Text(
                                    "Selanjutnya",
                                    style: TextStyle(
                                      color:
                                          controller.nextTopic.value == ""
                                              ? Colors.grey
                                              : Colors.black,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color:
                                        controller.nextTopic.value == ""
                                            ? Colors.grey
                                            : Colors.black,
                                  ),
                                ),
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
                          Obx(() {
                            if (!controller.isReady.value) {
                              return Skeletonizer(child: Text("data"));
                            } else {
                              if (controller.videoData['attachment'].length >
                                  0) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${controller.videoData['attachment'].length.toString()} Lampiran",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          context: context,
                                          builder: (context) {
                                            return SafeArea(
                                              child: SingleChildScrollView(
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                  spacing: 8,
                                                  children: [
                                                    Obx(() {
                                                      return ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            controller
                                                                .videoData['attachment']
                                                                .length,
                                                        itemBuilder: (
                                                          context,
                                                          i,
                                                        ) {
                                                          final attachment =
                                                              controller
                                                                  .videoData['attachment'][i];
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                attachment['judul'],
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  controller.download2(
                                                                    controller
                                                                        .dio,
                                                                    attachment['attachment'],
                                                                    "${attachment['judul']}.pdf",
                                                                  );
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .download,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        "Unduh Lampiran",
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return SizedBox();
                              }
                            }
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
                                        controller.selectedOption.value ==
                                        option;
                                    return GestureDetector(
                                      onTap: () {
                                        controller.selectedOption.value =
                                            option;

                                        Future.delayed(
                                          const Duration(seconds: 1),
                                          () {
                                            controller.keyEditor.currentState
                                                ?.clear();
                                            print(
                                              "RichEditor sudah di-clear setelah 5 detik",
                                            );
                                          },
                                        );
                                      },
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
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: "Tulis pertanyaanmu disini",
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
                                        onPressed: () {
                                          if (controller
                                                  .questionController
                                                  .text ==
                                              "") {
                                            Get.snackbar(
                                              "Gagal",
                                              "Mohon isi kolom komentar",
                                              backgroundColor: Colors.pink,
                                              colorText: Colors.white,
                                            );
                                            return;
                                          }
                                          controller.addComments(
                                            payload: {
                                              "comment":
                                                  controller
                                                      .questionController
                                                      .text,
                                              "video_topic_id":
                                                  controller.videoData['id'],
                                            },
                                          );
                                        },
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
                                          context: context,
                                        );
                                      },
                                    ),
                                    Obx(() {
                                      final current =
                                          controller.currentPage.value;
                                      final total = controller.totalPage.value;

                                      if (total <= 1) {
                                        return const SizedBox.shrink(); // tidak ada halaman
                                      }

                                      // Tentukan window
                                      int start = current - 1;
                                      int end = current + 1;

                                      // clamp biar tetap di antara 1 dan total
                                      start = start < 1 ? 1 : start;
                                      end = end > total ? total : end;

                                      // Kalau total < 3, pakai semua halaman yg ada
                                      if (total <= 3) {
                                        start = 1;
                                        end = total;
                                      } else {
                                        // Kalau current di awal → 1,2,3
                                        if (current == 1) {
                                          start = 1;
                                          end = 3;
                                        }
                                        // Kalau current di akhir → total-2, total-1, total
                                        else if (current == total) {
                                          start = total - 2;
                                          end = total;
                                        }
                                      }

                                      // Generate daftar halaman
                                      final pages = List.generate(
                                        end - start + 1,
                                        (i) => start + i,
                                      );

                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        height: 40,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                if (controller
                                                        .currentPage
                                                        .value >
                                                    1) {
                                                  controller
                                                      .currentPage
                                                      .value--;
                                                  controller.getComments(
                                                    controller.uuid,
                                                  );
                                                }
                                              },
                                              child: const Icon(
                                                Icons.arrow_back_ios,
                                                size: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 8),

                                            ...pages.map((page) {
                                              final isActive = page == current;
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 2,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .currentPage
                                                        .value = page;
                                                    controller.getComments(
                                                      controller.uuid,
                                                    );
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: Duration(
                                                      milliseconds: 200,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal:
                                                              isActive
                                                                  ? 14
                                                                  : 10,
                                                          vertical:
                                                              isActive ? 8 : 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          isActive
                                                              ? Colors
                                                                  .teal
                                                                  .shade100
                                                              : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            isActive
                                                                ? Colors.teal
                                                                : Colors
                                                                    .grey
                                                                    .shade300,
                                                        width: isActive ? 2 : 1,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      '$page',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            isActive
                                                                ? Colors.teal
                                                                : Colors.black,
                                                        fontSize:
                                                            isActive
                                                                ? 16
                                                                : 14, // font lebih besar untuk page aktif
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),

                                            const SizedBox(width: 8),
                                            TextButton(
                                              onPressed: () {
                                                if (controller
                                                        .currentPage
                                                        .value <
                                                    total) {
                                                  controller
                                                      .currentPage
                                                      .value++;
                                                  controller.getComments(
                                                    controller.uuid,
                                                  );
                                                }
                                              },
                                              child: const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              default:
                                return Column(
                                  spacing: 16,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return _noteForm(controller.isNote.value);
                                    }),
                                    // SizedBox(
                                    //   width: double.infinity,
                                    //   height: 300, // ✅ Tentukan tinggi
                                    //   child: Container(
                                    //     padding: EdgeInsets.all(16),
                                    //     decoration: BoxDecoration(
                                    //       border: Border.all(
                                    //         width: 0.5,
                                    //         color: Colors.grey,
                                    //       ),
                                    //     ),
                                    //     child: RichEditor(
                                    //       key: controller.keyEditor,
                                    //       editorOptions: RichEditorOptions(
                                    //         enableVideo: false,
                                    //         placeholder: 'Buat Catatan',
                                    //         padding: const EdgeInsets.symmetric(
                                    //           horizontal: 5.0,
                                    //         ),
                                    //         baseFontFamily: 'sans-serif',
                                    //         barPosition: BarPosition.TOP,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),

                                    // SizedBox(
                                    //   width: double.infinity,
                                    //   child: ElevatedButton(
                                    //     style: ElevatedButton.styleFrom(
                                    //       backgroundColor: Colors.teal,
                                    //       foregroundColor: Colors.white,
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(
                                    //           8,
                                    //         ),
                                    //       ),
                                    //       padding: const EdgeInsets.symmetric(
                                    //         vertical: 12,
                                    //       ),
                                    //     ),
                                    //     onPressed: () async {
                                    //       // Ambil HTML dari RichEditor
                                    //       final String? html =
                                    //           await controller
                                    //               .keyEditor
                                    //               .currentState
                                    //               ?.getHtml();

                                    //       // Pastikan tidak null
                                    //       if (html == null) {
                                    //         Get.snackbar(
                                    //           "Gagal",
                                    //           "Catatan tidak boleh kosong",
                                    //           backgroundColor: Colors.pink,
                                    //           colorText: Colors.white,
                                    //         );
                                    //         return;
                                    //       }

                                    //       // Bersihkan HTML dari tag kosong, whitespace, dan karakter yang tidak penting
                                    //       final cleanedHtml =
                                    //           html
                                    //               .replaceAll(
                                    //                 RegExp(r'<[^>]*>'),
                                    //                 '',
                                    //               ) // Hapus semua tag HTML
                                    //               .replaceAll(
                                    //                 RegExp(r'&nbsp;'),
                                    //                 '',
                                    //               ) // Hapus non-breaking space
                                    //               .trim();

                                    //       // Validasi setelah dibersihkan
                                    //       if (cleanedHtml.isEmpty) {
                                    //         Get.snackbar(
                                    //           "Gagal",
                                    //           "Catatan tidak boleh kosong",
                                    //           backgroundColor: Colors.pink,
                                    //           colorText: Colors.white,
                                    //         );
                                    //         return;
                                    //       }

                                    //       // Jika lolos validasi, kirim ke server
                                    //       controller.addNote(
                                    //         payload: {
                                    //           "durasi": controller.detik.value,
                                    //           "text":
                                    //               html, // Tetap kirim HTML aslinya
                                    //           "topicUuid":
                                    //               controller.videoData['uuid'],
                                    //         },
                                    //       );
                                    //     },

                                    //     child: const Text(
                                    //       "Buat",
                                    //       style: TextStyle(
                                    //         fontSize: 16,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(), // penting jika di dalam SingleChildScrollView
                                      itemCount: controller.noteList.length,
                                      itemBuilder: (context, index) {
                                        final data = controller.noteList[index];

                                        // Pastikan durasi selalu aman
                                        final durasiRaw = data['durasi'];
                                        final durasi =
                                            (durasiRaw is num)
                                                ? durasiRaw.floor()
                                                : 0;

                                        return _noteCard(
                                          data['uuid'],
                                          data['text'] ??
                                              '', // fallback kalau text null
                                          controller.formatDuration(durasi),
                                          data['durasi'],
                                          context,
                                        );
                                      },
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
      ),
    );
  }

  Widget _badge({
    required String title,
    required Color foregroundColor,
    required Color backgroundColor,
    double radius = 16,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
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
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 0, bottom: 16), // indent untuk balasan
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
                    Row(
                      children: [
                        Text(
                          data['user']?['name'] ?? "User",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        data['user']['is_admin'] == 1
                            ? _badge(
                              title: "Admin",
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal,
                            )
                            : SizedBox(),
                      ],
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    builder: (context) {
                      return SafeArea(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // === HEADER ===
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Balas Pertanyaan",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          controller.questionReplyController
                                              .clear();
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // === TEXT FIELD ===
                                  TextField(
                                    controller:
                                        controller.questionReplyController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: "Tulis pertanyaanmu disini",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.all(12),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // === BUTTON ===
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
                                      onPressed: () {
                                        final replyText =
                                            controller
                                                .questionReplyController
                                                .text
                                                .trim();

                                        if (replyText.isEmpty) {
                                          Get.snackbar(
                                            "Gagal",
                                            "Kolom pertanyaan tidak boleh kosong",
                                            backgroundColor: Colors.pink,
                                            colorText: Colors.white,
                                          );
                                          return;
                                        }

                                        controller.addComments(
                                          payload: {
                                            "comment": replyText,
                                            "video_topic_id":
                                                controller.videoData['id'],
                                            "parameter":
                                                controller.videoData['uuid'],
                                            "parent_id": data['id'],
                                          },
                                        );

                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Kirim",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  "Balas",
                  style: TextStyle(color: Colors.teal),
                ),
              ),

              // === Tombol Lihat/Sembunyikan Balasan ===
              if ((data['comment_reply'] as List?)?.isNotEmpty ?? false)
                Obx(() {
                  final isExpanded = controller.expandedReplies.contains(
                    data['id'],
                  );
                  return TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed:
                        () => controller.toggleReplyVisibility(data['id']),
                    child: Text(
                      isExpanded
                          ? "Sembunyikan Balasan"
                          : "Lihat Balasan (${(data['comment_reply'] as List).length.toString()})",
                      style: const TextStyle(color: Colors.teal),
                    ),
                  );
                }),
            ],
          ),

          // === List balasan komentar ===
          Obx(() {
            final isExpanded = controller.expandedReplies.contains(data['id']);
            if (!isExpanded)
              return const SizedBox.shrink(); // tidak tampil jika tidak di-expand

            return Column(
              children:
                  (data['comment_reply'] as List)
                      .map(
                        (reply) => _commentReplyData(
                          data: reply as Map<String, dynamic>,
                          isReply: true,
                          context: context,
                        ),
                      )
                      .toList(),
            );
          }),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Colors.grey.shade400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentReplyData({
    bool needPadding = true,
    required Map<String, dynamic> data,
    bool isReply = false,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.only(
        left: needPadding ? 32 : 0,
        top: 16,
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
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    builder: (context) {
                      return SafeArea(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // === HEADER ===
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Balas Pertanyaan",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          controller.questionReplyController
                                              .clear();
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // === TEXT FIELD ===
                                  TextField(
                                    controller:
                                        controller.questionReplyController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: "Tulis pertanyaanmu disini",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      contentPadding: const EdgeInsets.all(12),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // === BUTTON ===
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
                                      onPressed: () {
                                        final replyText =
                                            controller
                                                .questionReplyController
                                                .text
                                                .trim();

                                        if (replyText.isEmpty) {
                                          Get.snackbar(
                                            "Gagal",
                                            "Kolom pertanyaan tidak boleh kosong",
                                            backgroundColor: Colors.pink,
                                            colorText: Colors.white,
                                          );
                                          return;
                                        }

                                        controller.addComments(
                                          payload: {
                                            "comment":
                                                controller
                                                    .questionReplyController
                                                    .text,
                                            "video_topic_id":
                                                controller.videoData['id'],
                                            "parameter":
                                                controller.videoData['uuid'],
                                            "parent_id": data['id'],
                                          },
                                        );

                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Kirim",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  "Balas",
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
                        (reply) => _commentReplyData(
                          needPadding: false,
                          data: reply as Map<String, dynamic>,
                          isReply: true,
                          context: context,
                        ),
                      )
                      .toList(),
            ),
        ],
      ),
    );
  }

  Widget _noteCard(
    String uuid,
    String notes,
    String duration,
    num time,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          /// Header -> Badge + Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  controller.seekTo(time.toInt());
                },
                child: _badge(
                  title: duration,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  radius: 4,
                ),
              ),
              Row(
                children: [
                  /// Edit button
                  IconButton(
                    onPressed: () async {
                      await controller.keyEditEditor.currentState?.clear();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled:
                            true, // agar naik saat keyboard muncul
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (context) {
                          return SafeArea(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Header Edit
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Edit Catatan",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed:
                                              () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Editor
                                  Container(
                                    height: 300,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: RichEditor(
                                      key: controller.keyEditEditor,
                                      value: notes, // Set initial value di sini
                                      editorOptions: RichEditorOptions(
                                        enableVideo: false,
                                        placeholder: 'Edit Catatan',
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                        ),
                                        baseFontFamily: 'sans-serif',
                                        barPosition: BarPosition.TOP,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Tombol Simpan
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: SizedBox(
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
                                        onPressed: () async {
                                          final String? updatedHtml =
                                              await controller
                                                  .keyEditEditor
                                                  .currentState
                                                  ?.getHtml();

                                          if (updatedHtml == null ||
                                              updatedHtml.trim().isEmpty) {
                                            Get.snackbar(
                                              "Gagal",
                                              "Catatan tidak boleh kosong",
                                              backgroundColor: Colors.pink,
                                              colorText: Colors.white,
                                            );
                                            return;
                                          }

                                          controller.addNote(
                                            payload: {
                                              "durasi": time,
                                              "topicUuid":
                                                  controller.videoData['uuid'],
                                              "text": updatedHtml,
                                            },
                                          );

                                          Navigator.pop(context); // Tutup modal
                                        },
                                        child: const Text(
                                          "Simpan",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.teal),
                  ),

                  /// Delete button
                  IconButton(
                    onPressed: () {
                      Get.defaultDialog(
                        buttonColor: Colors.teal,
                        cancelTextColor: Colors.teal,
                        title: "Konfirmasi",
                        middleText:
                            "Apakah kamu yakin ingin menghapus catatan ini?",
                        textCancel: "Tidak",
                        textConfirm: "Ya",
                        confirmTextColor: Colors.white,
                        onCancel: () {},
                        onConfirm: () async {
                          Get.back();
                          await controller.deleteNotes(
                            payload: {
                              "durasi": time,
                              "topicUuid": controller.videoData['uuid'],
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.pink),
                  ),
                ],
              ),
            ],
          ),

          /// Konten catatan
          Card(
            color: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Html(
                data: notes,
                style: {
                  "img": Style(width: Width(240), display: Display.block),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteForm(bool isNote) {
    return isNote
        ? Column(
          spacing: 16,
          children: [
            Obx(
              () => SizedBox(
                width: 100,
                child: _badge(
                  title: controller.duration.value,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  radius: 4,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 300, // ✅ Tentukan tinggi
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                ),
                child: RichEditor(
                  key: controller.keyEditor,
                  editorOptions: RichEditorOptions(
                    enableVideo: false,
                    placeholder: 'Buat Catatan',
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    baseFontFamily: 'sans-serif',
                    barPosition: BarPosition.TOP,
                  ),
                ),
              ),
            ),

            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.teal),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      if (controller.isNote.value) {
                        controller.isNote.value = false;
                      } else {
                        controller.isNote.value = true;
                      }

                      Future.delayed(const Duration(seconds: 1), () {
                        controller.keyEditor.currentState?.clear();
                        print("RichEditor sudah di-clear setelah 5 detik");
                      });
                    },

                    child: const Text(
                      "Batal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      // Ambil HTML dari RichEditor
                      final String? html =
                          await controller.keyEditor.currentState?.getHtml();

                      // Pastikan tidak null
                      if (html == null) {
                        Get.snackbar(
                          "Gagal",
                          "Catatan tidak boleh kosong",
                          backgroundColor: Colors.pink,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Bersihkan HTML dari tag kosong, whitespace, dan karakter yang tidak penting
                      final cleanedHtml =
                          html
                              .replaceAll(
                                RegExp(r'<[^>]*>'),
                                '',
                              ) // Hapus semua tag HTML
                              .replaceAll(
                                RegExp(r'&nbsp;'),
                                '',
                              ) // Hapus non-breaking space
                              .trim();

                      // Validasi setelah dibersihkan
                      if (cleanedHtml.isEmpty) {
                        Get.snackbar(
                          "Gagal",
                          "Catatan tidak boleh kosong",
                          backgroundColor: Colors.pink,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Jika lolos validasi, kirim ke server
                      controller.addNote(
                        payload: {
                          "durasi": controller.detik.value,
                          "text": html, // Tetap kirim HTML aslinya
                          "topicUuid": controller.videoData['uuid'],
                        },
                      );
                      controller.playVideo();
                    },

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
            ),
          ],
        )
        : SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.teal),

                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              controller.pauseVideo();
              if (controller.isNote.value) {
                controller.isNote.value = false;
              } else {
                controller.isNote.value = true;
              }

              Future.delayed(const Duration(seconds: 1), () {
                controller.keyEditor.currentState?.clear();
                print("RichEditor sudah di-clear setelah 5 detik");
              });
            },
            child: Text(
              "Tulis Catatan pada ${controller.duration.value}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
  }
}
