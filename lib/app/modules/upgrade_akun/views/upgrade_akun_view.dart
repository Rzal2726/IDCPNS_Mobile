import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/upgrade_akun_controller.dart';

class UpgradeAkunView extends GetView<UpgradeAkunController> {
  const UpgradeAkunView({super.key});
  @override
  Widget build(BuildContext context) {
    String? selectedValue;

    final List<Map<String, dynamic>> features = [
      {"name": "50+ Video Series", "platinum": true, "basic": false},
      {"name": "20+ Materi Ebook", "platinum": true, "basic": false},
      {"name": "Ratusan Soal Tryout Harian", "platinum": true, "basic": false},
      {"name": "Bonus Tryout Bebas Pilih", "platinum": true, "basic": false},
      {"name": "Akses Premium Webinar", "platinum": true, "basic": false},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar("Upgrade Akun"),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jenis Paket",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Obx(
                      () =>
                          controller.listDurasi.isEmpty
                              ? Skeletonizer(
                                child: RadioListTile<String>(
                                  value: "",
                                  groupValue: selectedValue,
                                  onChanged: (value) {
                                    selectedValue = value;
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  title: Text("lorem ipsum"),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        "Rp.${(10000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}",
                                        style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Rp.${(10000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}",
                                        style: const TextStyle(
                                          color: Colors.teal,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : SizedBox(
                                width: double.infinity,
                                height: 180,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  shrinkWrap:
                                      true, // Penting jika di dalam Column atau SingleChildScrollView
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Agar scroll tetap pakai parent
                                  itemCount: controller.listDurasi.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.listDurasi[index];

                                    return Obx(
                                      () => RadioListTile<String>(
                                        value: item["uuid"].toString(),
                                        groupValue:
                                            controller.selectedDurasi.value,
                                        onChanged: (value) {
                                          controller.selectedDurasi.value =
                                              value ?? "";
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(item["name"] ?? ""),
                                        subtitle: Row(
                                          children: [
                                            // Harga asli dicoret
                                            Text(
                                              "Rp.${item["harga"].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}",
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Harga fix
                                            Text(
                                              "Rp.${item["harga_fix"].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}",
                                              style: const TextStyle(
                                                color: Colors.teal,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                    ),

                    Obx(
                      () =>
                          controller.listBonus.isEmpty
                              ? Skeletonizer(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.teal, // warna tombol
                                      foregroundColor:
                                          Colors.white, // warna teks/icon
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text("Loading"),
                                  ),
                                ),
                              )
                              : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.teal, // warna tombol
                                    foregroundColor:
                                        Colors.white, // warna teks/icon
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (controller.selectedDurasi.value == "") {
                                      Get.snackbar(
                                        "Gagal",
                                        "Silahkan pilih paket terlebih dahulu",
                                        backgroundColor: Colors.pink,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                      ),
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return SafeArea(
                                          child: Container(
                                            margin: EdgeInsets.only(top: 20),
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // ====== Header tetap di atas ======
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Bonus",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Silahkan Pilih Bonus",
                                                        ),
                                                      ],
                                                    ),
                                                    IconButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                      icon: const Icon(
                                                        Icons.close,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),

                                                // ====== ListView Scrollable ======
                                                Expanded(
                                                  child: ListView.builder(
                                                    itemCount:
                                                        controller
                                                            .listBonus
                                                            .length,
                                                    itemBuilder: (
                                                      context,
                                                      index,
                                                    ) {
                                                      final element =
                                                          controller
                                                              .listBonus[index];

                                                      return _bonusCard(
                                                        badgeText:
                                                            element['menu_category']?['menu'] ??
                                                            "CPNS",
                                                        badgeColor:
                                                            controller
                                                                .categoryColor[element['menu_category']?['menu']]!,
                                                        title:
                                                            element['formasi'] ??
                                                            "Bonus CPNS",
                                                        uuid:
                                                            element['uuid']
                                                                .toString(),
                                                      );
                                                    },
                                                  ),
                                                ),

                                                const SizedBox(height: 12),

                                                // ====== Tombol tetap di bawah ======
                                                SizedBox(
                                                  width: double.infinity,
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
                                                            horizontal: 12,
                                                            vertical: 12,
                                                          ),
                                                    ),
                                                    onPressed: () {
                                                      if (controller
                                                              .selectedBonusUuid
                                                              .value ==
                                                          "") {
                                                        Get.snackbar(
                                                          "Gagal",
                                                          "Silahkan pilih bonus terlebih dahulu",
                                                          backgroundColor:
                                                              Colors.pink,
                                                          colorText:
                                                              Colors.white,
                                                        );
                                                        return;
                                                      }
                                                      Navigator.pop(context);
                                                      controller
                                                          .upgradeSekarang();
                                                    },
                                                    child: const Text(
                                                      "Lanjutkan Pembayaran",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Upgrade Sekarang"),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Obx(() {
                if (controller.loading.value == true) {
                  return Skeletonizer(
                    child: Text("Loading..................."),
                  );
                } else {
                  return Expanded(
                    child: WebViewWidget(controller: controller.webController),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bonusCard({
    required String badgeText,
    required Color badgeColor,
    required String title,
    required String uuid,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey, width: 0.5),
      ),
      child: Obx(
        () => RadioListTile<String>(
          value: uuid,
          groupValue: controller.selectedBonusUuid.value,
          onChanged: (value) {
            controller.selectedBonusUuid.value = value!;
          },
          activeColor: const Color(0xFF0FA588), // warna custom
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: badgeColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
      ),
    );
  }
}
