import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/e_book_controller.dart';

class EBookView extends GetView<EBookController> {
  const EBookView({super.key});
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
            title: Text("E-Book"),
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
                      label: Text(
                        "Filter",
                        style: TextStyle(color: Colors.teal),
                      ),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
                    ),
                  ],
                ),
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
                    return Center(child: Text("Tidak ada data"));
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
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Obx(() {
                        if (controller.loading['ebook-list'] == true) {
                          return CircularProgressIndicator();
                        }
                        if (controller.eBookList.isEmpty) {
                          return Center(child: Text("Tidak Ada Data"));
                        }
                        return SafeArea(
                          child: SingleChildScrollView(
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
                                ...controller.eBookList.map((data) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text dari title
                                      Text(
                                        data['nama'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Tombol aksi
                                      TextButton(
                                        onPressed: () {
                                          Get.dialog(
                                            Dialog(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    // Title
                                                    Text(
                                                      "Syarat dan Ketentuan",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),

                                                    // Message
                                                    Text(
                                                      "Saya setuju untuk tidak menyebarkan konten-konten yang ada di website IDCPNS kepada pihak lain.",
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),

                                                    // Actions
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // Cancel Button
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                                side: BorderSide(
                                                                  color:
                                                                      Colors
                                                                          .teal,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              "Tidak Setuju",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.teal,
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
                                                                  Colors.teal,
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
                                                            child: Text(
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
                                          data['action'] ?? 'Aksi',
                                          style: const TextStyle(
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
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
