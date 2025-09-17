import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
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
            leading: IconButton(
              onPressed: () {
                Get.offAllNamed(
                  "/kategori-tryout-harian",
                  arguments: controller.uuid,
                );
              },
              icon: Icon(Icons.arrow_back),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text("Kategori"),
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
                  margin: EdgeInsets.all(16),
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
                                            Text("Lengkapi Form"),
                                            IconButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              icon: Icon(Icons.close),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        Row(children: [Text("Provinsi")]),
                                        SizedBox(height: 12),
                                        controller.listProvinsi.isEmpty
                                            ? Skeletonizer(child: Text("data"))
                                            : DropdownSearch<String>(
                                              popupProps: PopupProps.dialog(
                                                showSearchBox: true,
                                                searchFieldProps: TextFieldProps(
                                                  decoration: InputDecoration(
                                                    labelText: 'Cari Provinsi',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                dialogProps: DialogProps(
                                                  backgroundColor: Colors.white,
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
                                                      : controller.listProvinsi
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
                                        Row(children: [Text("Kota/Kabupaten")]),
                                        SizedBox(height: 12),
                                        Obx(() {
                                          return controller.listKota.isEmpty
                                              ? Skeletonizer(
                                                child: Text("data"),
                                              )
                                              : DropdownSearch<String>(
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
                                                              orElse: () => {},
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
                                                          .value =
                                                      selected['id'].toString();
                                                },
                                              );
                                        }),

                                        SizedBox(height: 24),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.teal,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                ),
                              );
                            },
                          );
                        },
                        label: Text(
                          "Filter",
                          style: TextStyle(color: Colors.teal),
                        ),
                        icon: Icon(Icons.list, color: Colors.teal),
                      ),
                    ],
                  ),
                ),
                Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: "Cari",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // warna tombol
                        foregroundColor: Colors.white, // warna teks/icon
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        controller.getUserPoint();
                      },
                      child: const Text("Cari"),
                    ),
                  ],
                ),
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
                            child: SvgPicture.asset("assets/learningEmpty.svg"),
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
                  return Row(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (controller.currentPage.value > 1) {
                            controller.currentPage.value = 1;
                            controller.getUserPoint();
                          }
                        },
                        icon: Icon(Icons.first_page),
                      ),
                      IconButton(
                        onPressed: () {
                          if (controller.currentPage.value > 1) {
                            controller.currentPage.value--;
                            controller.getUserPoint();
                          }
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      ...pages.map((page) {
                        final isActive = page == current;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          child: GestureDetector(
                            onTap: () {
                              controller.currentPage.value = page;
                              controller.getUserPoint();
                              controller.getPage();
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
                                  color: isActive ? Colors.teal : Colors.black,
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
                      IconButton(
                        onPressed: () {
                          if (controller.currentPage.value <
                              controller.totalPage.value) {
                            controller.currentPage.value++;
                            controller.getUserPoint();
                          }
                        },
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                      IconButton(
                        onPressed: () {
                          if (controller.currentPage.value <
                              controller.totalPage.value) {
                            controller.currentPage.value =
                                controller.totalPage.value;
                            controller.getUserPoint();
                          }
                        },
                        icon: Icon(Icons.last_page),
                      ),
                    ],
                  );
                }),
              ],
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
            Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 64,
                  child: _badge(color: Colors.blueAccent, text: num),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Nama peserta
            const SizedBox(height: 6),

            // Lokasi
            Row(
              children: [
                Text(
                  provisi,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.circle, color: Colors.grey, size: 8),
                const SizedBox(width: 6),
                Text(
                  kota,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
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
