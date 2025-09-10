import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../controllers/detail_tryout_saya_controller.dart';
import '../models/chart_data_model.dart';

class DetailTryoutSayaView extends GetView<DetailTryoutSayaController> {
  // ❌ REMOVED: Never put a controller inside the build method or as a view property.
  // final controller = Get.put(DetailTryoutSayaController());

  DetailTryoutSayaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Example: Hamburger icon for a drawer
          onPressed: () {
            Get.offNamed("/tryout-saya");
          },
        ),

        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Detail Tryout Saya"),
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
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              elevation: 1,
              child: Container(
                padding: EdgeInsets.all(12),
                child: Obx(
                  () => Column(
                    // spacing: 8, // ❌ REMOVED: This property does not exist
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          _badge(isi: "Premium", backgroundColor: Colors.amber),
                          controller.tryOutSaya['isdone'] == 1
                              ? _badge(
                                isi:
                                    controller.tryOutSaya['islulus'] == 1
                                        ? "Lulus"
                                        : "Tidak Lulus",
                                backgroundColor:
                                    controller.tryOutSaya['islulus'] == 1
                                        ? Colors.green
                                        : Colors.pink,
                              )
                              : _badge(
                                isi: "Belum Dikerjakan",
                                backgroundColor: Colors.grey,
                              ),
                        ],
                      ),
                      SizedBox(height: 12), // ✅ ADDED: Spacing
                      controller.tryOutSaya.isEmpty
                          ? Skeletonizer(
                            child: Text(
                              "Judul Tryout",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : Text(
                            controller.tryOutSaya['tryout']['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                      SizedBox(height: 8), // ✅ ADDED: Spacing
                      Text("Masa Aktif"),
                      SizedBox(height: 4), // ✅ ADDED: Spacing
                      SizedBox(
                        width: double.infinity,
                        child:
                            controller.tryOutSaya.isEmpty
                                ? Skeletonizer(child: _badge(isi: "180 Hari"))
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Progress Bar
                                    LinearProgressIndicator(
                                      value:
                                          (controller
                                                  .tryOutSaya['tryout']['reamining_day'] /
                                              controller
                                                  .hitungTotalMasaAktif(
                                                    controller
                                                        .tryOutSaya['created_at'],
                                                    controller
                                                        .tryOutSaya['expireddate'],
                                                  )
                                                  .toDouble()), // Progress 0.0 - 1.0
                                      backgroundColor: Colors.grey.shade300,
                                      color: Colors.teal.shade300,
                                      minHeight: 12, // Tinggi progress bar
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    const SizedBox(height: 8),

                                    // Text Sisa Hari
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Sisa Hari",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${controller.tryOutSaya['tryout']['reamining_day'].toString()} Hari Lagi",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                      ),
                      SizedBox(height: 16), // ✅ ADDED: Spacing
                      Obx(() {
                        if (controller.tryOutSaya.isEmpty) {
                          return Skeletonizer(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: Text("Loading"),
                              ),
                            ),
                          );
                        }

                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  controller.tryOutSaya['isdone'] == 1
                                      ? Colors.pink
                                      : Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              controller.checkList();
                              // Logic to handle button press
                              if (controller.tryOutSaya['isdone'] == 1) {
                                Get.defaultDialog(
                                  backgroundColor: Colors.white,
                                  title: "Konfirmasi",
                                  middleText:
                                      "Apakah kamu yakin ingin me-reset tryout?",
                                  textCancel: "Batal",
                                  textConfirm: "Ya, Reset",
                                  confirmTextColor: Colors.white,
                                  buttonColor: Colors.teal,
                                  onConfirm: () {
                                    controller.resetTryout();
                                    Get.back();
                                  },
                                  onCancel: () {},
                                  radius: 8,
                                );
                              } else {
                                showModalBottomSheet(
                                  backgroundColor: Colors.white,
                                  context: context,
                                  isScrollControlled:
                                      true, // biar bisa full height kalau perlu
                                  builder: (context) {
                                    return SizedBox(
                                      width:
                                          double
                                              .infinity, // <- kasih full width
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Lengkapi Form"),
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
                                            SizedBox(height: 12),
                                            controller.listInstansi.isEmpty
                                                ? Skeletonizer(
                                                  child: Text("data"),
                                                )
                                                : DropdownSearch<String>(
                                                  items: (f, cs) {
                                                    // Return Future<List<String>>
                                                    return controller
                                                        .listInstansi
                                                        .map(
                                                          (instansi) =>
                                                              instansi['nama']
                                                                  .toString(),
                                                        )
                                                        .toList();
                                                  },
                                                  selectedItem:
                                                      controller
                                                                  .selectedInstansi
                                                                  .value ==
                                                              ""
                                                          ? null
                                                          : controller
                                                              .listInstansi
                                                              .firstWhere(
                                                                (jabatan) =>
                                                                    jabatan['id']
                                                                        .toString() ==
                                                                    controller
                                                                        .selectedInstansi
                                                                        .value,
                                                                orElse:
                                                                    () => {
                                                                      'nama':
                                                                          '',
                                                                    },
                                                              )['nama'],

                                                  popupProps: PopupProps.dialog(
                                                    showSearchBox:
                                                        true, // ✅ Ada search bawaan
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
                                                  ),
                                                  decoratorProps: DropDownDecoratorProps(
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Pilih Instansi",
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    final selected = controller
                                                        .listInstansi
                                                        .firstWhere(
                                                          (instansi) =>
                                                              instansi['nama']
                                                                  .toString() ==
                                                              value,
                                                          orElse: () => {},
                                                        );
                                                    controller
                                                        .selectedInstansi
                                                        .value = selected['id']
                                                            .toString();
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
                                                ? Skeletonizer(
                                                  child: Text("data"),
                                                )
                                                : DropdownSearch<String>(
                                                  items: (f, cs) {
                                                    // Return Future<List<String>>
                                                    return controller
                                                        .listJabatan
                                                        .map(
                                                          (instansi) =>
                                                              instansi['nama']
                                                                  .toString(),
                                                        )
                                                        .toList();
                                                  },
                                                  selectedItem:
                                                      controller
                                                                  .selectedJabatan
                                                                  .value ==
                                                              ""
                                                          ? null
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
                                                                    () => {
                                                                      'nama':
                                                                          '',
                                                                    },
                                                              )['nama'],
                                                  popupProps: PopupProps.dialog(
                                                    showSearchBox:
                                                        true, // ✅ Ada search bawaan
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
                                                  ),
                                                  decoratorProps: DropDownDecoratorProps(
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Pilih Jabatan",
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    final selected = controller
                                                        .listJabatan
                                                        .firstWhere(
                                                          (instansi) =>
                                                              instansi['nama']
                                                                  .toString() ==
                                                              value,
                                                          orElse: () => {},
                                                        );
                                                    controller
                                                        .selectedJabatan
                                                        .value = selected['id']
                                                            .toString();
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
                                                  if (controller
                                                              .selectedInstansi
                                                              .value ==
                                                          "" ||
                                                      controller
                                                              .selectedInstansi
                                                              .value ==
                                                          "0") {
                                                    Get.snackbar(
                                                      "Alert",
                                                      "Mohon pilih instansi tujuan anda",
                                                      backgroundColor:
                                                          Colors.pink,
                                                      colorText: Colors.white,
                                                    );
                                                    return;
                                                  }
                                                  if (controller
                                                              .selectedJabatan
                                                              .value ==
                                                          "" ||
                                                      controller
                                                              .selectedJabatan
                                                              .value ==
                                                          "0") {
                                                    Get.snackbar(
                                                      "Alert",
                                                      "Mohon pilih jabatan tujuan anda",
                                                      backgroundColor:
                                                          Colors.pink,
                                                      colorText: Colors.white,
                                                    );
                                                    return;
                                                  }

                                                  controller.localStorage
                                                      .setString(
                                                        'jabatan',
                                                        controller
                                                            .selectedJabatan
                                                            .value,
                                                      );
                                                  controller.localStorage
                                                      .setString(
                                                        'instansi',
                                                        controller
                                                            .selectedInstansi
                                                            .value,
                                                      );
                                                  Navigator.pop(context);
                                                  Get.offNamed(
                                                    "/detail-pengerjaan-tryout",
                                                  );
                                                  controller.uuid.value =
                                                      controller.lateUuid;
                                                },
                                                child: Text("Lanjutkan Tryout"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            child: Text(
                              controller.tryOutSaya['isdone'] == 1
                                  ? "Ulangi Tryout"
                                  : "Kerjakan Tryout",
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Other widgets remain the same...
            // Make sure to apply the `colorFilter` fix to all your SVGs.
            // Example for the 'Rapor' button:
            Obx(() => _buildFeatureButtons()),
            SizedBox(height: 16),
            // If the tryout is not done, show a message. Otherwise, show the charts.
            Obx(
              () =>
                  controller.nilaiChart.isEmpty
                      ? Skeletonizer(child: Text("data"))
                      : controller.tryOutSaya['isdone'] == 1
                      ? _buildResultCharts()
                      : _buildPlaceholder(
                        "Kerjakan tryout untuk melihat hasil dan statistik.",
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for the placeholder text
  Widget _buildPlaceholder(String message) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ),
    );
  }

  Widget _passingGrade({
    required String title,
    required String score,
    required String passingGrade,
  }) {
    return Card(
      color: Colors.pink.shade100,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 12),
            Text(
              score,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Passing Grade: ", style: TextStyle(color: Colors.red)),
                Text(
                  passingGrade,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCharts() {
    return Column(
      children: [
        // Pie Chart untuk total nilai
        Card(
          color: Colors.white,
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Obx(() {
              if (controller.loading['chart'] == true) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.nilaiChart.isEmpty) {
                return const SizedBox();
              }

              final labels = controller.nilaiChart['charts']['labels'] as List;
              final values = controller.nilaiChart['charts']['values'] as List;

              // Cek apakah semua value 0
              final allZero = values.every(
                (value) => int.tryParse(value.toString()) == 0,
              );

              // Data yang akan ditampilkan di chart
              final List<ChartData> chartData =
                  allZero
                      ? [
                        ChartData(
                          "Tidak ada data",
                          "1",
                          Colors.grey.shade300, // Placeholder abu-abu
                        ),
                      ]
                      : List.generate(
                        labels.length,
                        (i) => ChartData(
                          labels[i], // Label: TWK, TIU, TKP
                          values[i],
                          Colors.primaries[i %
                              Colors.primaries.length], // Warna dinamis
                        ),
                      );

              return SfCircularChart(
                title: ChartTitle(
                  text: "Total Nilai",
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                legend: const Legend(
                  isVisible: true, // ✅ Menampilkan legenda
                  position: LegendPosition.bottom, // Posisi di bawah
                  overflowMode:
                      LegendItemOverflowMode.wrap, // Bungkus kalau kepanjangan
                  textStyle: TextStyle(fontSize: 12),
                ),
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper:
                        (ChartData data, _) => int.tryParse(data.y) ?? 0,
                    pointColorMapper: (ChartData data, _) => data.color,
                    innerRadius: '80%',
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true, // ✅ Menampilkan label
                      labelPosition: ChartDataLabelPosition.outside,
                      overflowMode: OverflowMode.shift,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),

        const SizedBox(height: 16),
        Obx(() {
          if (controller.loading['chart'] == true) {
            return Skeletonizer(child: Text("data"));
          }
          if (controller.nilaiChart['statistics'].isEmpty) {
            return SizedBox();
          }

          return Container(
            child: Column(
              children:
                  controller.nilaiChart['statistics'].map<Widget>((data) {
                    return _passingGrade(
                      title: data['title'],
                      score: data['result_nilai'].toString(),
                      passingGrade: data['nilai'].toString(),
                    );
                  }).toList(), // ✅ Convert ke List<Widget>
            ),
          );
        }),

        const SizedBox(height: 16),

        // Bar Chart untuk Benar / Salah / Kosong
        Obx(() {
          if (controller.loading['chart'] == true) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.chartData.isEmpty) {
            return SizedBox();
          }
          return Card(
            color: Colors.white,
            elevation: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                children: [
                  SfCartesianChart(
                    title: ChartTitle(
                      text: "Waktu Pengerjaan",
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    primaryXAxis: CategoryAxis(
                      labelRotation: -45,
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      labelRotation: 0,
                      title: AxisTitle(text: 'Waktu(Detik)'),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ColumnSeries>[
                      ColumnSeries<ChartData, String>(
                        dataSource: controller.chartDataList,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper:
                            (ChartData data, _) => int.tryParse(data.y),
                        pointColorMapper: (ChartData data, _) => data.color,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Total Waktu: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${(controller.totalValue.value / 60).floor().toString()} Menit",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        Obx(
          () =>
              controller.nilaiChartStat.isEmpty
                  ? const Skeletonizer(child: Text("data"))
                  : Column(
                    children:
                        (controller.nilaiChartStat['statistics']
                                as List<dynamic>)
                            .map((item) {
                              final subcategories =
                                  item['subcategories'] as List<dynamic>;

                              // Ubah subcategories menjadi list ChartData
                              final chartData =
                                  subcategories
                                      .map((sub) {
                                        return [
                                          ChartData(
                                            "${sub['title']} (Benar)",
                                            sub['benar'].toString(),
                                            Colors.green,
                                          ),
                                          ChartData(
                                            "${sub['title']} (Salah)",
                                            sub['salah'].toString(),
                                            Colors.red,
                                          ),
                                          ChartData(
                                            "${sub['title']} (Kosong)",
                                            sub['kosong'].toString(),
                                            Colors.orange,
                                          ),
                                        ];
                                      })
                                      .expand((e) => e)
                                      .toList();

                              return Card(
                                color: Colors.white,
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 0,
                                  ),
                                  child: Column(
                                    children: [
                                      // Chart untuk masing-masing label seperti TWK, TIU, TKP
                                      SfCartesianChart(
                                        title: ChartTitle(
                                          text: item['label'], // contoh: "TWK"
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        legend: Legend(
                                          isVisible: true,
                                          position: LegendPosition.bottom,
                                        ),
                                        tooltipBehavior: TooltipBehavior(
                                          enable: true,
                                        ),
                                        primaryXAxis: CategoryAxis(
                                          labelRotation: 0, // memutar text 45°
                                          labelStyle: const TextStyle(
                                            fontSize: 10,
                                          ), // memperkecil font
                                          majorGridLines: const MajorGridLines(
                                            width: 0,
                                          ),
                                        ),
                                        primaryYAxis: NumericAxis(
                                          minimum: 0,
                                          title: AxisTitle(text: 'Jumlah Soal'),
                                        ),

                                        series:
                                            <StackedBarSeries<dynamic, String>>[
                                              // Benar
                                              StackedBarSeries<dynamic, String>(
                                                name: 'Benar',
                                                color: Colors.green,
                                                dataSource: subcategories,
                                                xValueMapper:
                                                    (data, _) => data['title'],
                                                yValueMapper:
                                                    (data, _) => data['benar'],
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                      isVisible: true,
                                                    ),
                                              ),
                                              // Salah
                                              StackedBarSeries<dynamic, String>(
                                                name: 'Salah',
                                                color: Colors.red,
                                                dataSource: subcategories,
                                                xValueMapper:
                                                    (data, _) => data['title'],
                                                yValueMapper:
                                                    (data, _) => data['salah'],
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                      isVisible: true,
                                                    ),
                                              ),
                                              // Kosong
                                              StackedBarSeries<dynamic, String>(
                                                name: 'Kosong',
                                                color: Colors.grey,
                                                dataSource: subcategories,
                                                xValueMapper:
                                                    (data, _) => data['title'],
                                                yValueMapper:
                                                    (data, _) => data['kosong'],
                                                dataLabelSettings:
                                                    const DataLabelSettings(
                                                      isVisible: true,
                                                    ),
                                              ),
                                            ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                            .toList(),
                  ),
        ),
      ],
    );
  }

  // Helper for Rapor, Peringkat, Pembahasan buttons
  Widget _buildFeatureButtons() {
    bool isDone = controller.tryOutSaya['isdone'] == 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _featureButton(
            "Rapor",
            "assets/report.svg",
            Color(0xFF00A693),
            isDone,
            "/rapor",
          ),
          _featureButton(
            "Peringkat",
            "assets/trophy.svg",
            Color(0xFFFFA800),
            isDone,
            "/peringkat-tryout",
          ),
          _featureButton(
            "Pembahasan",
            "assets/book.svg",
            Color(0xFF00A8C5),
            isDone,
            "pembahasan-tryout",
          ),
        ],
      ),
    );
  }

  Widget _featureButton(
    String label,
    String assetPath,
    Color activeColor,
    bool isEnabled,
    String route,
  ) {
    return InkWell(
      onTap:
          isEnabled
              ? () {
                Get.toNamed(route, arguments: controller.tryOutSaya['uuid']);
              }
              : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              isEnabled ? activeColor.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled ? activeColor : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              width: 32,
              // ✅ FIXED: Use colorFilter instead of the deprecated color property
              colorFilter: ColorFilter.mode(
                isEnabled ? activeColor : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isEnabled ? activeColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge({
    required String? isi,
    Color backgroundColor = Colors.grey,
    Color foregroundColor = Colors.white,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Center(
          child: Text(
            isi ?? '',
            style: TextStyle(color: foregroundColor, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
