import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/tryout_saya_controller.dart';

class TryoutSayaView extends GetView<TryoutSayaController> {
  TryoutSayaView({super.key});

  final controller = Get.put(TryoutSayaController());
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
                  onPressed: () {},
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
                                                    .value = option;
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
                                          controller.optionsPengerjaan.value
                                              .map((option) {
                                                final isSelected =
                                                    controller
                                                        .selectedPengerjaan
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
                                                        .selectedPengerjaan
                                                        .value = option;
                                                  },
                                                );
                                              })
                                              .toList(),
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
                                          controller.optionsHasil.value.map((
                                            option,
                                          ) {
                                            final isSelected =
                                                controller
                                                    .selectedHasil
                                                    .value ==
                                                option;
                                            return ChoiceChip(
                                              label: Text(
                                                option,
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
                                                    option;
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

          Expanded(
            child: Obx(() {
              print("length = ${controller.listData.length}");
              return controller.listData.isNotEmpty
                  ? ListView.builder(
                    itemCount: controller.listData.length,
                    itemBuilder: (context, index) {
                      return _paketCard(
                        controller.listData[index]['kategori'].toString(),
                        controller.listData[index]['kategori'].toString(),
                        controller.listData[index]['status'].toString(),
                      );
                    },
                  )
                  : const Center(child: Text("No Data"));
            }),
          ),
        ],
      ),
    );
  }

  Widget _paketCard(String index, String kategori, String status) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                color: controller.categoryColors[kategori],
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(kategori, style: TextStyle(color: Colors.white)),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                color: controller.statusColors[status],
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(status, style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          Text("Lorem Ipsum Odoor", style: TextStyle(color: Colors.grey)),
          Text(
            "$index",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
