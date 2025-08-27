import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';

import '../controllers/detail_tryout_saya_controller.dart';

class DetailTryoutSayaView extends GetView<DetailTryoutSayaController> {
  const DetailTryoutSayaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      backgroundColor: Colors.green.shade200,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade300,
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
