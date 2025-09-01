import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/detail_tryout_saya_controller.dart';

class DetailTryoutSayaView extends GetView<DetailTryoutSayaController> {
  DetailTryoutSayaView({super.key});
  final List<ChartData> chartData = [
    ChartData('Benar', 7, Colors.green),
    ChartData('Salah', 1, Colors.red),
  ];
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
                  Get.to(NotificationView());
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
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _badge(isi: "Belum Dikerjakan"),
                        _badge(isi: "Belum Dikerjakan"),
                      ],
                    ),
                    Text(
                      "Judul Tryout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text("Masa Aktif"),
                    _badge(
                      isi: "180 Hari Lagi",
                      backgroundColor: Colors.teal.shade200,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade300,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Get.toNamed("detail-pengerjaan-tryout");
                        },
                        child: Text("Kerjakan Tryout"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset("assets/report.svg", width: 80),
                      Text("Rapor", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Column(
                    children: [
                      SvgPicture.asset("assets/trophy.svg", width: 80),
                      Text("Peringkat", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Column(
                    children: [
                      SvgPicture.asset("assets/book.svg", width: 80),
                      Text("Pembahasan", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  children: [
                    SizedBox(width: double.infinity),
                    SfCircularChart(
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
                                '20/40', // 👉 ganti sesuai value dinamis
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Benar/Salah', // subtitle optional
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
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          innerRadius: '80%',
                          pointColorMapper: (ChartData data, _) => data.color,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: double.infinity),
                    Text(
                      "Nilai",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Waktu Pengerjaan",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Untuk melihat statistik waktu pengerjaan silahkan kerjakan tryout ini terlebih dahulu.",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Statistik Nilai",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Untuk melihat statistik nilai silahkan kerjakan tryout ini terlebih dahulu.",
                            ),
                          ],
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

  Widget _badge({
    required String? isi,
    Color backgroundColor = Colors.grey,
    Color foregroundColor = Colors.white,
  }) {
    return Card(
      color: backgroundColor,
      child: Container(
        padding: EdgeInsets.all(4),
        child: Center(
          child: Text(isi!, style: TextStyle(color: foregroundColor)),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
