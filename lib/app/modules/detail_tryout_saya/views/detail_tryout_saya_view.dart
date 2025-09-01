import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/detail_tryout_saya_controller.dart';

class DetailTryoutSayaView extends GetView<DetailTryoutSayaController> {
  // 💡 Note: The chartData should ideally come from your controller and be reactive.
  // This is just a placeholder.
  final List<ChartData> chartData = [
    ChartData('Benar', 7, Colors.green),
    ChartData('Salah', 1, Colors.red),
    ChartData('Kosong', 2, Colors.grey), // Example for empty answers
  ];

  // ❌ REMOVED: Never put a controller inside the build method or as a view property.
  // final controller = Get.put(DetailTryoutSayaController());

  DetailTryoutSayaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                          _badge(
                            isi:
                                controller.tryOutSaya['isdone'] == 1
                                    ? "Selesai Dikerjakan"
                                    : "Belum Dikerjakan",
                            backgroundColor:
                                controller.tryOutSaya['isdone'] == 1
                                    ? Colors.green
                                    : Colors.orange,
                          ),
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
                              : SizedBox(),
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
                                : _badge(
                                  isi:
                                      "${controller.hitungMasaAktif(controller.tryOutSaya['expireddate'])} Hari Lagi",
                                  backgroundColor: Colors.teal.shade300,
                                  foregroundColor: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
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
                              backgroundColor: Colors.teal,
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
                                  },
                                  onCancel: () {},
                                  radius: 8,
                                );
                              } else {
                                showModalBottomSheet(
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
                                            DropdownButtonFormField<String>(
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
                                                          instansi['uuid']
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
                                            DropdownButtonFormField<String>(
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
                                                      value: jabatan['uuid'],
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
                                                  Get.toNamed(
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

            // If the tryout is not done, show a message. Otherwise, show the charts.
            Obx(
              () =>
                  controller.tryOutSaya['isdone'] == 1
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

  // Helper method to build the results section
  Widget _buildResultCharts() {
    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 1,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Obx(
              () =>
                  controller.nilaiChart.isEmpty
                      ? Skeletonizer(
                        child: Card(child: Center(child: Text("Skeleton"))),
                      )
                      : SfCircularChart(
                        title: ChartTitle(
                          text: "Total Nilai",
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            widget: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${controller.nilaiChart['total_nilai'].toString()}/${controller.nilaiChart['total_nilai_sempurna']}', // ✅ Dynamic data from controller
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Nilai/Nilai Sempurna', // subtitle optional
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        series: <CircularSeries>[
                          DoughnutSeries<ChartData, String>(
                            dataSource: [
                              ChartData(
                                "Nilai",
                                double.parse(
                                  controller.nilaiChart['total_nilai']
                                      .toString(),
                                ),
                                Colors.green,
                              ),
                              ChartData(
                                "Nilai Sempurna",
                                double.parse(
                                  controller.nilaiChart['total_nilai_sempurna'],
                                ),
                                Colors.pink,
                              ),
                            ], // ✅ Dynamic data from controller
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            innerRadius: '80%',
                            pointColorMapper: (ChartData data, _) => data.color,
                          ),
                        ],
                      ),
            ),
          ),
        ),
        Obx(
          () => Card(
            color: Colors.white,
            elevation: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child:
                  controller.nilaiChart.isEmpty
                      ? Skeletonizer(
                        child: Card(child: Center(child: Text("Skeleton"))),
                      )
                      : SfCartesianChart(
                        backgroundColor: Colors.white,
                        title: ChartTitle(
                          text: controller.nilaiChart['charts']['labels'][0],
                        ),
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          LineSeries<LineChart, String>(
                            name: "Nilai",
                            dataSource: [
                              LineChart(
                                "",
                                double.parse(
                                  controller.nilaiChart['charts']['values'][0],
                                ),
                              ),
                            ],
                            xValueMapper: (LineChart data, _) => data.x,
                            yValueMapper: (LineChart data, _) => data.y,
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                            ),
                            markerSettings: MarkerSettings(isVisible: true),
                          ),
                        ],
                      ),
            ),
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
          ),
          _featureButton(
            "Peringkat",
            "assets/trophy.svg",
            Color(0xFFFFA800),
            isDone,
          ),
          _featureButton(
            "Pembahasan",
            "assets/book.svg",
            Color(0xFF00A8C5),
            isDone,
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
  ) {
    return InkWell(
      onTap:
          isEnabled
              ? () {
                /* Navigation logic */
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

// This class should be in its own file, but is here for completeness.
class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class LineChart {
  LineChart(this.x, this.y);
  final String x;
  final double y;
}
