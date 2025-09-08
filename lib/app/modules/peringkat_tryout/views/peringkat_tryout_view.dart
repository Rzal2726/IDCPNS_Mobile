import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/peringkat_tryout_controller.dart';

class PeringkatTryoutView extends GetView<PeringkatTryoutController> {
  const PeringkatTryoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Peringkat"),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              child: Obx(
                () =>
                    controller.tryoutSaya.isEmpty
                        ? Skeletonizer(child: Text("Title"))
                        : Text(
                          controller.tryoutSaya['tryout']['name'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
              ),
            ),
            Card(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Hasil Peringkat Tryout",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          tooltip: "Filter",
                          onPressed: () {
                            if (controller.loading['filter'] == true) {
                              return;
                            }
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled:
                                  true, // biar bisa full height kalau perlu
                              builder: (context) {
                                return SizedBox(
                                  width: double.infinity, // <- kasih full width
                                  child: Padding(
                                    padding: EdgeInsets.all(32),
                                    child: Column(
                                      mainAxisSize:
                                          MainAxisSize
                                              .min, // biar nggak full screen
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
                                        Row(
                                          children: [
                                            Text(
                                              "*",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text("Provinsi"),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        controller.listProvinsi.isEmpty
                                            ? Skeletonizer(child: Text("data"))
                                            : DropdownButtonFormField<String>(
                                              value:
                                                  controller
                                                      .selectedProvinsi
                                                      .value,
                                              hint: Text("Pilih opsi"),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              isExpanded:
                                                  true, // <- penting biar dropdown nggak overflow
                                              items:
                                                  controller.listProvinsi.map((
                                                    jabatan,
                                                  ) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value:
                                                          jabatan['id']
                                                              .toString(),
                                                      child: Text(
                                                        jabatan['nama'],
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis, // handle nama panjang
                                                      ),
                                                    );
                                                  }).toList(),
                                              onChanged: (newValue) {
                                                controller
                                                    .selectedProvinsi
                                                    .value = newValue ?? "";
                                                controller.getKota();
                                              },
                                            ),

                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Text(
                                              "*",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text("Kota/Kabupaten"),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Obx(() {
                                          return controller.listKota.isEmpty
                                              ? Skeletonizer(
                                                child: Text("data"),
                                              )
                                              : DropdownButtonFormField<String>(
                                                value:
                                                    controller
                                                        .selectedKota
                                                        .value,
                                                hint: Text("Pilih opsi"),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                isExpanded:
                                                    true, // <- penting biar dropdown nggak overflow
                                                items:
                                                    controller.listKota.map((
                                                      instansi,
                                                    ) {
                                                      return DropdownMenuItem<
                                                        String
                                                      >(
                                                        value:
                                                            instansi['id']
                                                                .toString(),
                                                        child: Text(
                                                          instansi['nama']
                                                              .toString(),
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis, // handle nama panjang
                                                        ),
                                                      );
                                                    }).toList(),
                                                onChanged: (newValue) {
                                                  controller
                                                      .selectedKota
                                                      .value = newValue ?? "";
                                                },
                                              );
                                        }),

                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Text(
                                              "*",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text("Instansi Tujuan"),
                                          ],
                                        ),

                                        controller.listInstansi.isEmpty
                                            ? Skeletonizer(child: Text("data"))
                                            : DropdownButtonFormField<String>(
                                              value:
                                                  controller
                                                      .selectedInstansi
                                                      .value,
                                              hint: Text("Pilih opsi"),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              isExpanded:
                                                  true, // <- penting biar dropdown nggak overflow
                                              items:
                                                  controller.listInstansi.map((
                                                    instansi,
                                                  ) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value:
                                                          instansi['id']
                                                              .toString(),
                                                      child: Text(
                                                        instansi['nama']
                                                            .toString(),
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis, // handle nama panjang
                                                      ),
                                                    );
                                                  }).toList(),
                                              onChanged: (newValue) {
                                                controller
                                                    .selectedInstansi
                                                    .value = newValue ?? "";
                                              },
                                            ),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Text(
                                              "*",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text("Jabatan Tujuan"),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        controller.listJabatan.isEmpty
                                            ? Skeletonizer(child: Text("data"))
                                            : DropdownButtonFormField<String>(
                                              value:
                                                  controller
                                                      .selectedJabatan
                                                      .value,
                                              hint: Text("Pilih opsi"),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              isExpanded:
                                                  true, // <- penting biar dropdown nggak overflow
                                              items:
                                                  controller.listJabatan.map((
                                                    jabatan,
                                                  ) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value:
                                                          jabatan['id']
                                                              .toString(),
                                                      child: Text(
                                                        jabatan['nama'],
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis, // handle nama panjang
                                                      ),
                                                    );
                                                  }).toList(),
                                              onChanged: (newValue) {
                                                controller
                                                    .selectedJabatan
                                                    .value = newValue ?? "";
                                              },
                                            ),

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
                                              controller.getRanking();
                                              Navigator.pop(context);
                                            },
                                            child: Text("Filter"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Statistik cards
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: _cardBorder(
                          color: Colors.grey,
                          title: controller.total.value.toString(),
                          subTitle: "Total Peserta",
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: _cardBorder(
                          color: Colors.teal,
                          title: controller.pesertaLulus.value.toString(),
                          subTitle: "Peserta Lulus",
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: _cardBorder(
                          color: Colors.red,
                          title: controller.pesertTidakLulus.value.toString(),
                          subTitle: "Peserta Tidak Lulus",
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: _cardBorder(
                          bgColor: Colors.yellow.shade100,
                          color: Colors.yellow.shade300,
                          title: "Anda berada di peringkat",
                          subTitle:
                              "${controller.rank.value.toString()} Dari ${controller.total.value.toString()}",
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Search bar
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(color: Colors.grey),
                              labelText: "Cari Disini",
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.teal,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                          ),
                          onPressed: () {
                            controller.getRanking();
                          },
                          child: const Text(
                            "Cari",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Obx(
                      () =>
                          controller.listPeringkat.isEmpty
                              ? Skeletonizer(
                                child: _cardData(
                                  num: "1",
                                  name: "name",
                                  provisi: "provisi",
                                  kota: "kota",
                                  score: "score",
                                  status: 1,
                                ),
                              )
                              : SizedBox(
                                width: double.infinity,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: controller.listPeringkat.length,
                                  itemBuilder: (context, index) {
                                    final data =
                                        controller.listPeringkat[index];
                                    return _cardData(
                                      num: data['no'].toString(),
                                      name: data['user_name'],
                                      provisi: data['provinsi_nama'],
                                      kota: data['kabupaten_nama'],
                                      score: data['total'].toString(),
                                      status: data['islulus'],
                                    );
                                  },
                                ),
                              ),
                    ),

                    Row(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (controller.currentPage.value > 1) {
                              controller.currentPage.value--;
                              controller.getRanking();
                            }
                          },
                          icon: Icon(Icons.arrow_back_ios),
                        ),
                        Text("1"),
                        IconButton(
                          onPressed: () {
                            if (controller.currentPage.value <
                                controller.totalPage.value) {
                              controller.currentPage.value++;
                              controller.getRanking();
                            }
                          },
                          icon: Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                    Text(
                      "Catatan",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Html(
                          data:
                              "<ol><li>Faktor lulus/tidak peserta bukan ditentukan dari total nilai, namun passing grade masing-masing kategori.</li><li>Nilai yang ditampilkan pada ranking adalah nilai pengerjaan pertama kali</li></ol>",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardBorder({
    Color? bgColor,
    required Color color,
    required String title,
    required String subTitle,
  }) {
    return Card(
      elevation: 0,
      color: bgColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.5, color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(subTitle),
          ],
        ),
      ),
    );
  }

  Widget _cardData({
    required String num,
    required String name,
    required String provisi,
    required String kota,
    required String score,
    required int status,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Nilai
                const Text(
                  "Nilai",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Flexible(
                  child: _badge(
                    color: status == 1 ? Colors.green : Colors.red,
                    text: score,
                  ),
                ),
                const Text(
                  "Keterangan",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Flexible(
                  child: _badge(
                    color: status == 1 ? Colors.green : Colors.red,
                    text: status == 1 ? "Lulus" : "Tidak Lulus",
                  ),
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
