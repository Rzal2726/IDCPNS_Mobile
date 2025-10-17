import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/searchWithButton.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/peringkat_tryout_controller.dart';

class PeringkatTryoutView extends GetView<PeringkatTryoutController> {
  const PeringkatTryoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(400),
        child: secondaryAppBar("Peringkat"),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () => controller.initPeringkat(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
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
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              iconAlignment: IconAlignment.end,
                              onPressed: () {
                                if (controller.loading['filter'] == true) {
                                  return;
                                }
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Filter"),
                                                  IconButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
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
                                                            controller
                                                                .listProvinsi
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
                                                                  orElse:
                                                                      () => {},
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
                                                          selected['id']
                                                              .toString();
                                                      controller.getKota();
                                                    },
                                                  ),
                                              SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Text("Kota/Kabupaten"),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              Obx(() {
                                                return controller
                                                        .listKota
                                                        .isEmpty
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
                                                            labelText:
                                                                'Cari Kota',
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
                                                              controller
                                                                  .listKota
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
                                                              : controller
                                                                  .listKota
                                                                  .firstWhere(
                                                                    (kota) =>
                                                                        kota['id']
                                                                            .toString() ==
                                                                        controller
                                                                            .selectedKota
                                                                            .value,
                                                                    orElse:
                                                                        () =>
                                                                            {},
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
                                                            selected['id']
                                                                .toString();
                                                        controller
                                                            .getInstansi();
                                                      },
                                                    );
                                              }),
                                              SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Text("Instansi Tujuan"),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              controller.listInstansi.isEmpty
                                                  ? Skeletonizer(
                                                    child: Text("data"),
                                                  )
                                                  : DropdownSearch<String>(
                                                    popupProps: PopupProps.dialog(
                                                      showSearchBox: true,
                                                      searchFieldProps: TextFieldProps(
                                                        decoration: InputDecoration(
                                                          labelText:
                                                              'Cari Instansi',
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
                                                            controller
                                                                .listInstansi
                                                                .map(
                                                                  (instansi) =>
                                                                      instansi['nama']
                                                                          .toString(),
                                                                )
                                                                .toList(),
                                                    selectedItem:
                                                        controller
                                                                    .selectedInstansi
                                                                    .value ==
                                                                ""
                                                            ? "Pilih Instansi"
                                                            : controller
                                                                .listInstansi
                                                                .firstWhere(
                                                                  (instansi) =>
                                                                      instansi['id']
                                                                          .toString() ==
                                                                      controller
                                                                          .selectedInstansi
                                                                          .value,
                                                                  orElse:
                                                                      () => {},
                                                                )['nama']
                                                                .toString(),
                                                    onChanged: (newValue) {
                                                      final selected = controller
                                                          .listInstansi
                                                          .firstWhere(
                                                            (instansi) =>
                                                                instansi['nama'] ==
                                                                newValue,
                                                            orElse: () => {},
                                                          );
                                                      controller
                                                              .selectedInstansi
                                                              .value =
                                                          selected['id']
                                                              .toString();
                                                    },
                                                  ),
                                              SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Text("Jabatan Tujuan"),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              controller.listJabatan.isEmpty
                                                  ? Skeletonizer(
                                                    child: Text("data"),
                                                  )
                                                  : DropdownSearch<String>(
                                                    popupProps: PopupProps.dialog(
                                                      showSearchBox: true,
                                                      searchFieldProps: TextFieldProps(
                                                        decoration: InputDecoration(
                                                          labelText:
                                                              'Cari Jabatan',
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
                                                            controller
                                                                .listJabatan
                                                                .map(
                                                                  (jabatan) =>
                                                                      jabatan['nama']
                                                                          .toString(),
                                                                )
                                                                .toList(),
                                                    selectedItem:
                                                        controller
                                                                    .selectedJabatan
                                                                    .value ==
                                                                ""
                                                            ? "Pilih Jabatan"
                                                            : controller
                                                                .listJabatan
                                                                .firstWhere(
                                                                  (jabatan) =>
                                                                      jabatan['id']
                                                                          .toString() ==
                                                                      controller
                                                                          .selectedJabatan
                                                                          .value,
                                                                  orElse:
                                                                      () => {},
                                                                )['nama']
                                                                .toString(),
                                                    onChanged: (newValue) {
                                                      final selected = controller
                                                          .listJabatan
                                                          .firstWhere(
                                                            (jabatan) =>
                                                                jabatan['nama'] ==
                                                                newValue,
                                                            orElse: () => {},
                                                          );
                                                      controller
                                                              .selectedJabatan
                                                              .value =
                                                          selected['id']
                                                              .toString();
                                                    },
                                                  ),
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
                                                          controller
                                                              .selectedInstansi
                                                              .value = '';
                                                          controller
                                                              .selectedJabatan
                                                              .value = '';
                                                          controller
                                                              .getRanking();
                                                          Navigator.pop(
                                                            context,
                                                          );
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
                                                          controller
                                                              .getRanking();
                                                          Navigator.pop(
                                                            context,
                                                          );
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
                              title:
                                  controller.pesertTidakLulus.value.toString(),
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
                              child: SearchRowButton(
                                controller: controller.searchController,
                                onSearch: () {
                                  controller.getRanking();
                                },
                                hintText: 'Cari',
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
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          controller.listPeringkat.length,
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

                        Obx(() {
                          if (controller.totalPage.value == 0) {
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
                                  controller.getRanking();
                                },
                                prevPage: () {
                                  if (controller.currentPage.value > 1) {
                                    controller.currentPage.value--;
                                    controller.getRanking();
                                  }
                                },
                                nextPage: () {
                                  if (controller.currentPage.value <
                                      controller.totalPage.value) {
                                    controller.currentPage.value++;
                                    controller.getRanking();
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 16),
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
              spacing: 4,
              children: [
                SizedBox(
                  width: 50,
                  child: _badge(color: Colors.blueAccent, text: num),
                ),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
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
                Expanded(
                  child: Text(
                    provisi,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.circle, color: Colors.grey, size: 8),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    kota,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
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
                  "Nilai : ",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Flexible(
                  child: _badge(
                    color: status == 1 ? Colors.green : Colors.red,
                    text: score,
                  ),
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
