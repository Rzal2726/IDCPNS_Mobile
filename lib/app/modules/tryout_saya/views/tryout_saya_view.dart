import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/tryout_saya_controller.dart';

class TryoutSayaView extends GetView<TryoutSayaController> {
  TryoutSayaView({super.key});

  final controller = Get.put(TryoutSayaController());
  final cariController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Tryout Saya'),
        centerTitle: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 32, top: 16, right: 32),
            child: Text(
              "Tryout Saya",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 32, bottom: 16, right: 32),
            child: Text(
              "Segera kerjakan tryout kamu dan dapatkan hasil tertinggi.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          SizedBox(height: 8),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cariController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: "Cari",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color.fromRGBO(185, 246, 202, 1),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.tealAccent.shade100,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      controller.search.value = value;
                    },
                  ),
                ),
                SizedBox(width: 8),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // warna tombol
                    foregroundColor: Colors.white, // warna teks/icon
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    controller.fetchTryoutSaya();
                  },
                  label: Text("Cari"),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          // filter button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (ctx) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize
                                        .min, // biar bottomsheet menyesuaikan isi
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          controller.listCategory.map((option) {
                                            final isSelected =
                                                controller
                                                    .selectedPaketKategori
                                                    .value ==
                                                option['menu'];
                                            return ChoiceChip(
                                              label: Text(
                                                option['menu'],
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
                                                    BorderRadius.circular(6),
                                              ),
                                              onSelected: (value) {
                                                controller
                                                    .selectedPaketKategori
                                                    .value = option['menu'];
                                                controller.kategoriId.value =
                                                    option['id'].toString();
                                              },
                                            );
                                          }).toList(),
                                    ),
                                  ),

                                  SizedBox(height: 12),

                                  const Text(
                                    "Status Pengerjaan",
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
                                          controller.optionsPengerjaan.map((
                                            option,
                                          ) {
                                            final isSelected =
                                                controller
                                                    .selectedPengerjaan
                                                    .value ==
                                                option['isDone']!;
                                            return ChoiceChip(
                                              label: Text(
                                                option['isDone']!,
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
                                                    BorderRadius.circular(6),
                                              ),
                                              onSelected: (value) {
                                                controller
                                                    .selectedPengerjaan
                                                    .value = option['isDone']!;
                                                controller.isDone.value =
                                                    option['value']!;
                                              },
                                            );
                                          }).toList(),
                                    ),
                                  ),

                                  SizedBox(height: 12),

                                  const Text(
                                    "Hasil Pengerjaan",
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
                                          controller.optionsHasil.map((option) {
                                            final isSelected =
                                                controller
                                                    .selectedHasil
                                                    .value ==
                                                option['isLulus'];
                                            return ChoiceChip(
                                              label: Text(
                                                option['isLulus']!,
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
                                                    BorderRadius.circular(6),
                                              ),
                                              onSelected: (value) {
                                                controller.selectedHasil.value =
                                                    option['isLulus']!;
                                                controller.isLulus.value =
                                                    option['value']!;
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed: () {
                                        controller.fetchTryoutSaya();
                                        Navigator.pop(context);
                                        // kirim balik pilihan
                                      },
                                      child: const Text("Cari"),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Text("Filter", style: TextStyle(color: Colors.teal)),
                      Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Obx(() {
            if (controller.isLoading['list'] == true) {
              // 🔹 Loading state
              return SizedBox(
                width: double.infinity,
                child: Skeletonizer(
                  enabled: true,
                  child: _paketCard(
                    "",
                    "kategori",
                    "judul",
                    "bundle",
                    isDone: true,
                    isLulus: true,
                  ),
                ),
              );
            }

            return controller.listData.isNotEmpty
                ? Expanded(
                  child: ListView.builder(
                    itemCount: controller.listData.length,
                    itemBuilder: (context, index) {
                      final data = controller.listData[index];
                      return _paketCard(
                        data['uuid'],
                        data['id']['menu'].toString(),
                        data['name'].toString(),
                        data['id']['formasi'].toString(),
                        bgcolor: controller.categoryColors[data['id']['menu']],
                        isDone: data['isdone'] == 1,
                        isLulus: data['islulus'] == 1,
                      );
                    },
                  ),
                )
                : SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            "assets/learning-empty-e208cbbc.svg",
                          ),
                          Text(
                            "Tidak ada tryout",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
          }),
          // Obx(() {
          //   final current = controller.currentPage.value;
          //   final total = controller.totalPage.value;

          //   if (total == 0) {
          //     return const SizedBox.shrink(); // tidak ada halaman
          //   }

          //   // Tentukan window
          //   int start = current - 1;
          //   int end = current + 1;

          //   // clamp biar tetap di antara 1 dan total
          //   start = start < 1 ? 1 : start;
          //   end = end > total ? total : end;

          //   // Kalau total < 3, pakai semua halaman yg ada
          //   if (total <= 3) {
          //     start = 1;
          //     end = total;
          //   } else {
          //     // Kalau current di awal → 1,2,3
          //     if (current == 1) {
          //       start = 1;
          //       end = 3;
          //     }
          //     // Kalau current di akhir → total-2, total-1, total
          //     else if (current == total) {
          //       start = total - 2;
          //       end = total;
          //     }
          //   }

          //   // Generate daftar halaman
          //   final pages = List.generate(end - start + 1, (i) => start + i);

          //   return Container(
          //     margin: const EdgeInsets.symmetric(horizontal: 16),
          //     height: 40,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         ElevatedButton(
          //           onPressed:
          //               current > 1
          //                   ? () => controller.fetchPaketTryout(
          //                     page: current - 1,
          //                     search: paketTextController.text,
          //                     menuCategory:
          //                         controller
          //                             .optionsId[controller
          //                                 .selectedPaketKategori
          //                                 .value]
          //                             .toString(),
          //                   )
          //                   : null,
          //           child: const Icon(Icons.arrow_back_ios, size: 16),
          //         ),
          //         const SizedBox(width: 8),

          //         ...pages.map((page) {
          //           final isActive = page == current;
          //           return Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 2),
          //             child: ElevatedButton(
          //               onPressed:
          //                   () => controller.fetchPaketTryout(
          //                     page: page,
          //                     search: paketTextController.text,
          //                     menuCategory:
          //                         controller
          //                             .optionsId[controller
          //                                 .selectedPaketKategori
          //                                 .value]
          //                             .toString(),
          //                   ),
          //               style: ElevatedButton.styleFrom(
          //                 minimumSize: const Size(36, 36),
          //                 backgroundColor:
          //                     isActive ? Colors.teal : Colors.white,
          //                 foregroundColor:
          //                     isActive ? Colors.white : Colors.black54,
          //               ),
          //               child: Text(
          //                 page.toString(),
          //                 style: const TextStyle(fontSize: 14),
          //               ),
          //             ),
          //           );
          //         }),

          //         const SizedBox(width: 8),
          //         ElevatedButton(
          //           onPressed:
          //               current < total
          //                   ? () => controller.fetchPaketTryout(
          //                     page: current + 1,
          //                     search: paketTextController.text,
          //                     menuCategory:
          //                         controller
          //                             .optionsId[controller
          //                                 .selectedPaketKategori
          //                                 .value]
          //                             .toString(),
          //                   )
          //                   : null,
          //           child: const Icon(Icons.arrow_forward_ios, size: 16),
          //         ),
          //       ],
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }

  Widget _paketCard(
    String uuid,
    String kategori,
    String judul,
    String bundle, {
    Color? bgcolor,
    required bool isDone,
    required bool isLulus,
    String? status, // opsional kalau mau dipakai
  }) {
    return InkWell(
      onTap: () {
        controller.selectedUuid.value = uuid;
        Get.toNamed("detail-tryout-saya", arguments: uuid);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row kategori + status
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: controller.menuColors[kategori],
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      kategori,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color:
                      isDone
                          ? (isLulus ? Colors.green : Colors.red)
                          : Colors.grey,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      isDone
                          ? (isLulus ? "Lulus" : "Tidak Lulus")
                          : "Belum Dikerjakan",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Bundle name
            Text(
              bundle,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 4),

            // Judul tryout
            Container(
              width: 300,
              child: Text(
                judul,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
