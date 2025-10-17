import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/e_book_controller.dart';

class EBookView extends GetView<EBookController> {
  const EBookView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar("E-Book"),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () => controller.initEbook(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: AppStyle.sreenPaddingHome,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
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
                                                            .selectedKategori
                                                            .value =
                                                        option['id'].toString();
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
                                            controller.getEbook();
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Filter', style: TextStyle(color: Colors.teal)),
                        Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Obx(() {
                  if (controller.loading['ebook'] == true) {
                    return Skeletonizer(
                      child: _dataCard(
                        category: "CPNS",
                        judul: "Teks Materi Lengkap CPNS",
                        categoryColor: Colors.teal,
                        bab: "23",
                        id: "1",
                        context: context,
                      ),
                    );
                  }
                  if (controller.eBook.isEmpty) {
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
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.eBook.length,
                    itemBuilder: (itemBuilder, index) {
                      final data = controller.eBook[index];
                      return SizedBox(
                        child: _dataCard(
                          category: data['menu_category']['menu'],
                          judul: data['nama'],
                          categoryColor:
                              controller
                                  .categoryColor[data['menu_category']['menu']]!,
                          bab: data['ebook_list'].length.toString(),
                          id: data['id'].toString(),
                          context: context,
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataCard({
    required String category,
    required String judul,
    required Color categoryColor,
    required String bab,
    required String id,
    required BuildContext context,
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
            SizedBox(
              width: 100,
              child: _badge(
                title: category,
                foregroundColor: Colors.white,
                backgroundColor: categoryColor,
              ),
            ),
            Text(
              judul,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("${bab} Subab", style: TextStyle(color: Colors.grey)),
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
                onPressed: () async {
                  await controller.getEbookList(id);
                  showModalBottomSheet(
                    useSafeArea: false,
                    backgroundColor: Colors.white,
                    isScrollControlled: false,
                    context: context,
                    builder: (context) {
                      return Obx(() {
                        if (controller.loading['ebook-list'] == true) {
                          return CircularProgressIndicator();
                        }
                        if (controller.eBookList.isEmpty) {
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
                        }
                        return SafeArea(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Pilih E-Book",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.close),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: controller.eBookList.length,
                                    shrinkWrap:
                                        true, // biar bisa dipakai di dalam widget lain seperti Column
                                    itemBuilder: (context, index) {
                                      final data = controller.eBookList[index];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // ===== Teks judul eBook =====
                                            Expanded(
                                              child: Text(
                                                data['nama'] ?? '',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),

                                            // ===== Tombol Aksi =====
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Get.dialog(
                                                  Dialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            16,
                                                          ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          // ===== Title =====
                                                          const Text(
                                                            "Syarat dan Ketentuan",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),

                                                          // ===== Message =====
                                                          const Text(
                                                            "Saya setuju untuk tidak menyebarkan konten-konten "
                                                            "yang ada di website IDCPNS kepada pihak lain.",
                                                            textAlign:
                                                                TextAlign
                                                                    .justify,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),

                                                          // ===== Action Buttons =====
                                                          Row(
                                                            children: [
                                                              // Cancel Button
                                                              Expanded(
                                                                child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                      side: const BorderSide(
                                                                        color:
                                                                            Colors.teal,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    Get.back();
                                                                  },
                                                                  child: const Text(
                                                                    "Tidak Setuju",
                                                                    style: TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .teal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),

                                                              // Confirm Button
                                                              Expanded(
                                                                child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .teal,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    Get.back();
                                                                    Get.toNamed(
                                                                      "/pdf-viewer",
                                                                      arguments:
                                                                          data['link'],
                                                                    );
                                                                  },
                                                                  child: const Text(
                                                                    "Setuju",
                                                                    style: TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .white,
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
                                                );
                                              },
                                              child: Text(
                                                data['action'] ?? 'Buka',
                                                style: const TextStyle(
                                                  color: Colors.teal,
                                                ),
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
                          ),
                        );
                      });
                    },
                  );
                },
                child: const Text(
                  "Buka E-Book",
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
