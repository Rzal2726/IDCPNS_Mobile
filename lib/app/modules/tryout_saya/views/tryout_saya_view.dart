import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/searchWithButton.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';

import '../controllers/tryout_saya_controller.dart';

class TryoutSayaView extends GetView<TryoutSayaController> {
  TryoutSayaView({super.key});

  final controller = Get.put(TryoutSayaController());
  final cariController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: secondaryAppBar("Tryout Saya"),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.initAll(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 18),
                  child: SearchRowButton(
                    controller: cariController,
                    onSearch: () {
                      controller.currentPage.value = 1;
                      controller.fetchTryoutSaya();
                    },
                    hintText: 'Cari',
                  ),
                ),
                SizedBox(height: 16),

                // filter button
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 18),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
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
                                return SafeArea(
                                  child: SingleChildScrollView(
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  controller.aturUlang();
                                                },
                                                child: Text(
                                                  "Atur Ulang",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.pink,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                                                  controller.listCategory.map((
                                                    option,
                                                  ) {
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
                                                            .selectedPaketKategori
                                                            .value = option['menu'];
                                                        controller
                                                                .kategoriId
                                                                .value =
                                                            option['id']
                                                                .toString();
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
                                                                .selectedPengerjaan
                                                                .value =
                                                            option['isDone']!;
                                                        controller
                                                                .isDone
                                                                .value =
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
                                                  controller.optionsHasil.map((
                                                    option,
                                                  ) {
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
                                                                .selectedHasil
                                                                .value =
                                                            option['isLulus']!;
                                                        controller
                                                                .isLulus
                                                                .value =
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
                                                controller.currentPage.value =
                                                    1;
                                                controller.fetchTryoutSaya();
                                                Navigator.pop(context);
                                                // kirim balik pilihan
                                              },
                                              child: const Text("Cari"),
                                            ),
                                          ),
                                        ],
                                      ),
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
                ),

                SizedBox(height: 16),

                // The rest of your code is unchanged...
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
                      ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            controller.listData.length +
                            1, // Add 1 for the pagination widget
                        itemBuilder: (context, index) {
                          if (index == controller.listData.length) {
                            // Render the pagination widget at the end
                            final current = controller.currentPage.value;
                            final total = controller.totalPage.value;

                            if (total == 0 || current < 1) {
                              return const SizedBox.shrink();
                            }

                            int start = current - 1;
                            int end = current + 1;

                            start = start < 1 ? 1 : start;
                            end = end > total ? total : end;

                            if (total <= 3) {
                              start = 1;
                              end = total;
                            } else {
                              if (current == 1) {
                                start = 1;
                                end = 3;
                              } else if (current == total) {
                                start = total - 2;
                                end = total;
                              }
                            }

                            if (end < start) {
                              end = start;
                            }

                            final pages = List.generate(
                              end - start + 1,
                              (i) => start + i,
                            );

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Tombol pertama
                                    TextButton.icon(
                                      onPressed: () async {
                                        controller.currentPage.value = 1;
                                        controller.fetchTryoutSaya();
                                      },
                                      label: const Icon(
                                        Icons.first_page,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                    ),

                                    // Tombol sebelumnya
                                    TextButton.icon(
                                      onPressed: () async {
                                        if (controller.currentPage.value > 1) {
                                          controller.currentPage.value--;
                                          controller.fetchTryoutSaya();
                                        }
                                      },
                                      label: Icon(
                                        Icons.arrow_back_ios,
                                        size: 16,
                                        color:
                                            controller.currentPage.value > 1
                                                ? Colors.black
                                                : Colors.grey,
                                      ),
                                    ),

                                    // Nomor halaman
                                    ...pages.map((page) {
                                      final isActive = page == current;
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.currentPage.value = page;
                                            controller.fetchTryoutSaya();
                                          },
                                          child: AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 200,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: isActive ? 14 : 10,
                                              vertical: isActive ? 8 : 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isActive
                                                      ? Colors.teal.shade100
                                                      : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                fontSize: isActive ? 16 : 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),

                                    // Tombol berikutnya
                                    TextButton.icon(
                                      onPressed: () {
                                        if (controller.currentPage.value <
                                            controller.totalPage.value) {
                                          controller.currentPage.value++;
                                          controller.fetchTryoutSaya();
                                        }
                                      },
                                      label: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color:
                                            controller.currentPage.value <
                                                    controller.totalPage.value
                                                ? Colors.black
                                                : Colors.grey,
                                      ),
                                    ),

                                    // Tombol terakhir
                                    TextButton.icon(
                                      onPressed: () {
                                        controller.currentPage.value =
                                            controller.totalPage.value;
                                        controller.fetchTryoutSaya();
                                      },
                                      label: const Icon(
                                        Icons.last_page,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          // Render the _paketCard for all other indices
                          final data = controller.listData[index];
                          return _paketCard(
                            data['uuid'],
                            data['id']['menu'].toString(),
                            data['name'].toString(),
                            data['id']['formasi'].toString(),
                            bgcolor:
                                controller.categoryColors[data['id']['menu']],
                            isDone: data['isdone'] == 1,
                            isLulus: data['islulus'] == 1,
                          );
                        },
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
              ],
            ),
          ),
        ),
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
