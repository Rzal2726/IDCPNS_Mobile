import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/searchWithButton.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/peringkat_tryout_harian_controller.dart';

class PeringkatTryoutHarianView
    extends GetView<PeringkatTryoutHarianController> {
  const PeringkatTryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar(
        "Peringkat",
        onBack: () {
          Get.offAllNamed(
            "/kategori-tryout-harian",
            arguments: controller.uuid,
          );
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () => controller.initRank(),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() {
                    if (controller.loading['init'] == true) {
                      return Skeletonizer(child: _rankCard("0", "0"));
                    } else {
                      if (controller.dataPoint.isEmpty) {
                        return _rankCard("0", "0");
                      } else {
                        return _rankCard(
                          controller.dataPoint[0]['my_rank'].toString(),
                          controller.dataPointPage['total'].toString(),
                        );
                      }
                    }
                  }),
                  SizedBox(width: double.infinity),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hasil Peringkat Tryout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          iconAlignment: IconAlignment.end,
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return SafeArea(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.all(32),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Filter"),
                                              IconButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                icon: Icon(Icons.close),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                          Row(children: [Text("Provinsi")]),
                                          SizedBox(height: 12),
                                          controller.listProvinsi.isEmpty
                                              ? Skeletonizer(
                                                child: Text("data"),
                                              )
                                              : DropdownSearch<String>(
                                                popupProps: PopupProps.dialog(
                                                  showSearchBox: true,
                                                  searchFieldProps: TextFieldProps(
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Cari Provinsi',
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  dialogProps: DialogProps(
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                items:
                                                    (f, cs) =>
                                                        controller.listProvinsi
                                                            .map(
                                                              (provinsi) =>
                                                                  provinsi['nama']
                                                                      .toString(),
                                                            )
                                                            .toList(),
                                                selectedItem:
                                                    controller
                                                                .selectedProvinsi
                                                                .value ==
                                                            ""
                                                        ? "Pilih Provinsi"
                                                        : controller
                                                            .listProvinsi
                                                            .firstWhere(
                                                              (provinsi) =>
                                                                  provinsi['id']
                                                                      .toString() ==
                                                                  controller
                                                                      .selectedProvinsi
                                                                      .value,
                                                              orElse: () => {},
                                                            )['nama']
                                                            .toString(),
                                                onChanged: (newValue) {
                                                  final selected = controller
                                                      .listProvinsi
                                                      .firstWhere(
                                                        (provinsi) =>
                                                            provinsi['nama'] ==
                                                            newValue,
                                                        orElse: () => {},
                                                      );
                                                  controller
                                                          .selectedProvinsi
                                                          .value =
                                                      selected['id'].toString();
                                                  controller.getKota();
                                                },
                                              ),
                                          SizedBox(height: 12),
                                          Row(
                                            children: [Text("Kota/Kabupaten")],
                                          ),
                                          SizedBox(height: 12),
                                          Obx(() {
                                            return controller.listKota.isEmpty
                                                ? Skeletonizer(
                                                  child: Text("data"),
                                                )
                                                : DropdownSearch<String>(
                                                  enabled:
                                                      controller
                                                          .selectedProvinsi
                                                          .value
                                                          .isNotEmpty,
                                                  popupProps: PopupProps.dialog(
                                                    showSearchBox: true,
                                                    searchFieldProps: TextFieldProps(
                                                      decoration: InputDecoration(
                                                        labelText: 'Cari Kota',
                                                        border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    dialogProps: DialogProps(
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  items:
                                                      (f, cs) =>
                                                          controller.listKota
                                                              .map(
                                                                (kota) =>
                                                                    kota['nama']
                                                                        .toString(),
                                                              )
                                                              .toList(),
                                                  selectedItem:
                                                      controller
                                                                  .selectedKota
                                                                  .value ==
                                                              ""
                                                          ? "Pilih Kota/Kabupaten"
                                                          : controller.listKota
                                                              .firstWhere(
                                                                (kota) =>
                                                                    kota['id']
                                                                        .toString() ==
                                                                    controller
                                                                        .selectedKota
                                                                        .value,
                                                                orElse:
                                                                    () => {},
                                                              )['nama']
                                                              .toString(),
                                                  onChanged: (newValue) {
                                                    final selected = controller
                                                        .listKota
                                                        .firstWhere(
                                                          (kota) =>
                                                              kota['nama'] ==
                                                              newValue,
                                                          orElse: () => {},
                                                        );
                                                    controller
                                                        .selectedKota
                                                        .value = selected['id']
                                                            .toString();
                                                  },
                                                );
                                          }),

                                          SizedBox(height: 24),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      controller
                                                          .selectedKota
                                                          .value = '';
                                                      controller
                                                          .selectedProvinsi
                                                          .value = '';
                                                      controller.getUserPoint();
                                                      Navigator.pop(context);
                                                    },
                                                    // tutup bottom sheet
                                                    style: OutlinedButton.styleFrom(
                                                      side: BorderSide(
                                                        color: Colors.teal,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      "Reset",
                                                      style: TextStyle(
                                                        color: Colors.teal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.teal,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                    ),
                                                    onPressed: () {
                                                      controller.getUserPoint();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Filter"),
                                                  ),
                                                ),
                                              ],
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
                          label: Text(
                            "Filter",
                            style: TextStyle(color: Colors.teal),
                          ),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: SearchRowButton(
                          controller: controller.searchController,
                          onSearch: () {
                            controller.getUserPoint();
                          },
                          hintText: 'Cari',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Obx(() {
                    if (controller.loading["init"] == true) {
                      return Skeletonizer(
                        child: _cardData(
                          num: "1",
                          name: "rizal",
                          provisi: "Jawa",
                          kota: "Jawa",
                          score: "90",
                        ),
                      );
                    } else {
                      if (controller.dataPoint.isEmpty) {
                        return Column(
                          spacing: 32,
                          children: [
                            const SizedBox(height: 32),
                            SizedBox(
                              height: 200,
                              child: SvgPicture.asset(
                                "assets/learningEmpty.svg",
                              ),
                            ),
                            const Text(
                              "No Data",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.dataPoint.length,
                          itemBuilder: (context, index) {
                            final item = controller.dataPoint[index];
                            return _cardData(
                              num: item['rank'].toString(),
                              name: item['user']['name'],
                              provisi: item['provinsi']['nama'],
                              kota: item['kotakab']['nama'],
                              score: item['total_point'].toString(),
                            );
                          },
                        );
                      }
                    }
                  }),
                  Obx(() {
                    final current = controller.currentPage.value;
                    final total = controller.totalPage.value;

                    if (total == 0) {
                      return const SizedBox.shrink(); // tidak ada halaman
                    }

                    if (controller.dataPoint.isEmpty) {
                      return const SizedBox.shrink(); // tidak ada halaman
                    }

                    return Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: ReusablePagination(
                          currentPage: controller.currentPage,
                          totalPage: controller.totalPage,
                          goToPage: (int page) {
                            controller.currentPage.value = page;
                            controller.getUserPoint();
                          },
                          prevPage: () {
                            if (controller.currentPage.value > 1) {
                              controller.currentPage.value--;
                              controller.getUserPoint();
                            }
                          },
                          nextPage: () {
                            if (controller.currentPage.value <
                                controller.totalPage.value) {
                              controller.currentPage.value++;
                              controller.getUserPoint();
                            }
                          },
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

  Widget _rankCard(String myRank, String totalRank) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromARGB(255, 255, 242, 205),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(width: double.infinity),
          Text("Anda Berada di peringkat $myRank dari $totalRank peserta"),
        ],
      ),
    );
  }

  Widget _cardData({
    required String num,
    required String name,
    required String provisi,
    required String kota,
    required String score,
  }) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.5, color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge nomor
            SizedBox(
              width: double.infinity,
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 64,
                    child: _badge(color: Colors.blueAccent, text: num),
                  ),
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Nama peserta
            const SizedBox(height: 6),

            // Lokasi
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      provisi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.circle, color: Colors.grey, size: 8),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      kota,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24, thickness: 0.7, color: Colors.grey),

            // Nilai & Keterangan
            Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Nilai
                const Text(
                  "Nilai",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(
                  width: 64,
                  child: _badge(color: Colors.green, text: score),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge({required Color color, required String text}) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(child: Text(text, style: TextStyle(color: Colors.white))),
      ),
    );
  }
}
