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
      body: Container(
        margin: EdgeInsets.all(8),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        useSafeArea: false,
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (ctx) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return SafeArea(
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize:
                                        MainAxisSize
                                            .min, // biar bottomsheet menyesuaikan isi
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Jenis Tryout",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      Obx(
                                        () => Wrap(
                                          spacing: 8,
                                          children:
                                              controller.options.value.map((
                                                option,
                                              ) {
                                                final isSelected =
                                                    controller
                                                        .selectedPaketKategori
                                                        .value ==
                                                    option;
                                                return ChoiceChip(
                                                  label: Text(
                                                    option,
                                                    style: TextStyle(
                                                      color:
                                                          isSelected
                                                              ? Colors.teal
                                                              : Colors
                                                                  .grey[700],
                                                      fontWeight:
                                                          isSelected
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                    ),
                                                  ),
                                                  selected: isSelected,
                                                  selectedColor: Colors.teal
                                                      .withOpacity(0.1),
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      color:
                                                          isSelected
                                                              ? Colors.teal
                                                              : Colors
                                                                  .grey
                                                                  .shade400,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  onSelected: (value) {
                                                    controller
                                                        .selectedPaketKategori
                                                        .value = option;
                                                  },
                                                );
                                              }).toList(),
                                        ),
                                      ),

                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.teal, // warna tombol
                                            foregroundColor:
                                                Colors.white, // warna teks/icon
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            controller.fetchVideoData();
                                          },
                                          child: const Text("Cari"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
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
                        isActive: true,
                      ),
                    );
                  }

                  // Saat data ada
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    itemCount: controller.listVideo.length,
                    itemBuilder: (context, index) {
                      final data = controller.listVideo[index];
                      return _cardVidio(
                        imgUrl: data['gambar'],
                        kategori: data['menu_category']['menu'],
                        kategoriColor:
                            controller
                                .categoryColor[data['menu_category']['menu']]!,
                        title: data['nama'],
                        duration: data['total_durasi'].toString(),
                        totalVid: data['video_topics'].length.toString(),
                        data: data,
                        isActive: data['isopen'] == 1,
                      );
                    },
                  );
                }),
                Obx(() {
                  final current = controller.currentPage.value;
                  final total = controller.totalPage.value;

                  if (total == 0) {
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
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              if (current > 1) {
                                controller.currentPage.value = 1;
                                controller.fetchVideoData();
                              }
                            },
                            label: const Icon(Icons.first_page, size: 16),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              if (current > 1) {
                                controller.currentPage.value--;
                                controller.fetchVideoData();
                              }
                            },
                            label: const Icon(Icons.arrow_back_ios, size: 16),
                          ),

                          ...pages.map((page) {
                            final isActive = page == current;
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              child: GestureDetector(
                                onTap: () {
                                  controller.currentPage.value = page;
                                  controller.fetchVideoData();
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isActive ? 14 : 10,
                                    vertical: isActive ? 8 : 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isActive
                                            ? Colors.teal.shade100
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          isActive
                                              ? Colors.teal
                                              : Colors.grey.shade300,
                                      width: isActive ? 2 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    '$page',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isActive ? Colors.teal : Colors.black,
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

                          TextButton.icon(
                            onPressed: () {
                              if (current < total) {
                                controller.currentPage.value++;
                                controller.fetchVideoData();
                              }
                            },
                            label: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              if (current < total) {
                                controller.currentPage.value = total;
                                controller.fetchVideoData();
                              }
                            },
                            label: const Icon(Icons.last_page, size: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
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
    required bool isActive,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
            width: 100,
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
                backgroundColor: isActive ? Colors.teal : Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                if (isActive == true) {
                  Get.toNamed("/watch-video", arguments: data);
                }
              },
              child: Text("Tonton Sekarang"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge({
    required String? isi,
    Color backgroundColor = Colors.grey,
    Color foregroundColor = Colors.white,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          isi ?? '',
          style: TextStyle(color: foregroundColor, fontSize: 12),
        ),
      ),
    );
  }
}
