import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
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
            title: Text("Webinar"),
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
                            Text("Tidak Ada E-Book"),
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
                            status: data['status'],
                            category: data['menu_category']['menu'],
                            judul: data['nama'],
                            categoryColor:
                                controller
                                    .categoryColor[data['menu_category']['menu']]!,
                            tanggal: formattedDate,
                            jam: formattedTime,
                            img: Image.network(data['gambar']),
                          );
                        },
                      );
                    }
                  }
                }),
              ],
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
  }) {
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
                  title: status == 1 ? "Selesai" : "Belum Mulai",
                  foregroundColor: Colors.white,
                  backgroundColor: status == 1 ? Colors.teal : Colors.grey,
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
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Get.toNamed("/detail-webinar", arguments: uuid);
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
}
