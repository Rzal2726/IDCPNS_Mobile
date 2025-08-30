import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/bimbelRicord/controllers/bimbel_ricord_controller.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

class BimbelRecordView extends GetView<BimbelRecordController> {
  const BimbelRecordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Rekaman", style: AppStyle.appBarTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppStyle.screenPadding,
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return Container(
              padding: AppStyle.contentPadding,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // warna bayangan
                    blurRadius: 6, // seberapa blur bayangannya
                    spreadRadius: 2, // seberapa melebar bayangan
                    offset: Offset(0, 3), // posisi bayangan (x, y)
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rekaman Bimbel",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.rekamanList.length,
                      itemBuilder: (context, index) {
                        final item = controller.rekamanList[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['judul'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Hari",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(item['hari']),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Tanggal",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(item['tanggal']),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Jam",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(item['jam']),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  minimumSize: Size(double.infinity, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () => controller.tontonVideo(item),
                                icon: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Tonton",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
