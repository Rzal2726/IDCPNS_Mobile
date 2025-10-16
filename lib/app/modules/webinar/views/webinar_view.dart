import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/webinar_controller.dart';

class WebinarView extends GetView<WebinarController> {
  const WebinarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar("Webinar"),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.teal,
          onRefresh: () => controller.initEbook(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                        ),
                        iconAlignment: IconAlignment.end,
                        onPressed: () {
                          showModalBottomSheet(
                            useSafeArea: false,
                            context: context,
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
                                            "Kategori",
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
                                                  controller.categoryList.map((
                                                    option,
                                                  ) {
                                                    final isSelected =
                                                        controller
                                                            .selectedKategori
                                                            .value ==
                                                        option['id'].toString();
                                                    return ChoiceChip(
                                                      label: Text(
                                                        option['menu'],
                                                        style: TextStyle(
                                                          color:
                                                              isSelected
                                                                  ? Colors.teal
                                                                  : Colors
                                                                      .grey[700],
                                                          fontWeight:
                                                              isSelected
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                        ),
                                                      ),
                                                      selected: isSelected,
                                                      selectedColor: Colors.teal
                                                          .withOpacity(0.1),
                                                      backgroundColor:
                                                          Colors.white,
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
                                                            .selectedKategori
                                                            .value = option['id']
                                                                .toString();
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
                                                    Colors
                                                        .white, // warna teks/icon
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12,
                                                    ),
                                              ),
                                              onPressed: () {
                                                controller.getWebinar();
                                                Navigator.pop(context);
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
                        label: Text(
                          "Filter",
                          style: TextStyle(color: Colors.teal),
                        ),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
                      ),
                    ],
                  ),
                  Obx(() {
                    if (controller.loading['webinar'] == true) {
                      return Skeletonizer(
                        child: _dataCard(
                          status: 0,
                          category: "CPNS",
                          judul: "Teks Materi Lengkap CPNS",
                          categoryColor: Colors.teal,
                          tanggal: "17 Agustus",
                          jam: "20:00",
                          img: Image.asset("assets/webinar.png"),
                          unformattedDate: "2025-11-15 20:00:00",
                        ),
                      );
                    } else {
                      if (controller.webinarList.isEmpty) {
                        return Center(
                          child: Column(
                            spacing: 16,
                            children: [
                              SizedBox(height: 64),
                              SvgPicture.asset(
                                "assets/learningEmpty.svg",
                                width: 240,
                              ),
                              Text("Tidak Ada Webinar"),
                            ],
                          ),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.webinarList.length,
                          itemBuilder: (context, index) {
                            final data = controller.webinarList[index];
                            // 1. Pisahkan tanggal dan waktu
                            List<String> parts = data['tanggal'].split(" ");
                            String datePart = parts[0]; // "2025-11-15"
                            String timePart = parts[1]; // "20:00:00"

                            // 2. Format tanggal ke dalam bentuk "27 Desember"
                            DateTime parsedDate = DateTime.parse(datePart);
                            String formattedDate = DateFormat(
                              "d MMMM y",
                            ).format(parsedDate);
                            String formattedTime = DateFormat(
                              "HH:mm",
                            ).format(DateTime.parse("$datePart $timePart"));

                            return _dataCard(
                              uuid: data['uuid'],
                              status: data['iscompleted'],
                              category: data['menu_category']['menu'],
                              judul: data['nama'],
                              categoryColor:
                                  controller
                                      .categoryColor[data['menu_category']['menu']]!,
                              tanggal: formattedDate,
                              jam: formattedTime,
                              unformattedDate: data['tanggal'],
                              img: Image.network(data['gambar']),
                            );
                          },
                        );
                      }
                    }
                  }),
                  SizedBox(height: 16),
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
                                  controller.getWebinar();
                                }
                              },
                              label: const Icon(Icons.first_page, size: 16),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                if (current > 1) {
                                  controller.currentPage.value--;
                                  controller.getWebinar();
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
                                    controller.getWebinar();
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

                            TextButton.icon(
                              onPressed: () {
                                if (current < total) {
                                  controller.currentPage.value++;
                                  controller.getWebinar();
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
                                  controller.getWebinar();
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
      ),
    );
  }

  Widget _dataCard({
    String uuid = "",
    required String category,
    required int status,
    required String judul,
    required Color categoryColor,
    required String tanggal,
    required String jam,
    required Image img,
    required String unformattedDate,
  }) {
    final tgl = DateTime.parse(unformattedDate);
    final now = DateTime.now();

    bool canAccess =
        now.isAfter(tgl) && now.isBefore(tgl.add(const Duration(days: 1)));

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: double.infinity, child: img),
            Row(
              children: [
                _badge(
                  title: category,
                  foregroundColor: Colors.white,
                  backgroundColor: categoryColor,
                ),
                _badge(
                  title:
                      status == 1
                          ? "Selesai"
                          : canAccess
                          ? "Sedang Berlangsung"
                          : "Belum Mulai",
                  foregroundColor: Colors.white,
                  backgroundColor:
                      status == 1
                          ? Colors.teal
                          : canAccess
                          ? Colors.amber
                          : Colors.grey,
                ),
              ],
            ),
            Text(
              judul,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("${tanggal}"),
            Row(
              children: [
                Icon(Icons.hourglass_empty_sharp, color: Colors.amber),
                Text(jam),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAccess ? Colors.teal : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  if (canAccess) {
                    Get.toNamed("/detail-webinar", arguments: uuid);
                  } else {
                    Get.snackbar(
                      "Gagal",
                      "Webinar belum dimulai atau sudah selesai",
                      colorText: Colors.white,
                      backgroundColor: Colors.pink,
                    );
                  }
                },
                child: const Text(
                  "Ikuti Webinar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
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
      shape: RoundedRectangleBorder(
        // side: BorderSide(),
        borderRadius: BorderRadius.circular(16),
      ),
      color: backgroundColor,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Center(
          child: Text(title, style: TextStyle(color: foregroundColor)),
        ),
      ),
    );
  }
}
