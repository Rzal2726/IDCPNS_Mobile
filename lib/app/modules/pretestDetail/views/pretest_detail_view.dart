import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/pretest_detail_controller.dart';

class PretestDetailView extends GetView<PretestDetailController> {
  const PretestDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: basicAppBarWithoutNotif("Detail Pretest"),
      body: Obx(() {
        final isLoading = controller.item.isEmpty;

        return SafeArea(
          child: SingleChildScrollView(
            padding: AppStyle.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informasi Pretest
                Skeletonizer(
                  enabled: isLoading,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoading ? " " : "Informasi Pretest",
                          style: AppStyle.style17Bold,
                        ),
                        SizedBox(height: 20),
                        Text(
                          isLoading ? " " : "${controller.item['judul']}",
                          style: AppStyle.style17Bold,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isLoading ? " " : "Jumlah Soal",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              isLoading
                                  ? " "
                                  : "${controller.item['jumlah_soal']} Soal",
                              style: AppStyle.style15Bold,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isLoading ? " " : "Waktu Pengerjaan",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              isLoading
                                  ? " "
                                  : "${controller.item['waktu_pengerjaan']} Menit",
                              style: AppStyle.style15Bold,
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                minimumSize: Size(double.infinity, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed:
                                  isLoading ? null : controller.mulaiPretest,
                              child: Text(
                                "Mulai Pretest",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity, 40),
                                side: BorderSide(color: Colors.teal),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed:
                                  isLoading ? null : controller.lihatPanduan,
                              child: Text(
                                "Panduan",
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Peraturan Pretest
                Skeletonizer(
                  enabled: isLoading,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoading ? " " : "Peraturan Pretest",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Skeletonizer(
                          enabled: isLoading, // true saat data belum dimuat
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.peraturan.length,
                            itemBuilder: (context, index) {
                              final aturan = controller.peraturan[index];
                              final isFirst = index == 0;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${index + 1}. "),
                                    Expanded(
                                      child: Text(
                                        aturan,
                                        style: TextStyle(
                                          color:
                                              isFirst
                                                  ? Colors.red
                                                  : Colors.black,
                                          fontSize: 15,
                                        ),
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
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
