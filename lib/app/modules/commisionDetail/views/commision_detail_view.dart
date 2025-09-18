import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/commision_detail_controller.dart';

class CommisionDetailView extends GetView<CommisionDetailController> {
  const CommisionDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar(
        "Afiliasi",
        onBack: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Padding(
              padding: AppStyle.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search box
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Cari",
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      suffixIcon: Icon(Icons.search, color: Colors.black54),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Card Rincian Komisi
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rincian Komisi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 50),
                            child:
                                controller.komisiDetailData['data'] == null ||
                                        controller
                                            .komisiDetailData['data']
                                            .isEmpty
                                    ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/emptyArchiveIcon.svg", // ilustrasi kosong
                                            height: 100,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Tidak ada transaksi",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    : Column(
                                      children: [
                                        for (
                                          var i = 0;
                                          i <
                                              controller
                                                  .komisiDetailData['data']
                                                  .length;
                                          i++
                                        )
                                          if (controller
                                                  .komisiDetailData['data'][i]['user'] !=
                                              null)
                                            buildRincianKomisi(
                                              number: i + 1,
                                              name:
                                                  controller
                                                      .komisiDetailData['data'][i]['user_name']
                                                      .toString(),
                                              date:
                                                  controller
                                                      .komisiDetailData['data'][i]['tanggal'] ??
                                                  '',
                                              price: formatRupiah(
                                                hitungKomisiDetail(
                                                  amount:
                                                      controller
                                                          .komisiDetailData['data'][i]['amount'] ??
                                                      0,
                                                  amountAdmin:
                                                      controller
                                                          .komisiDetailData['data'][i]['amount_admin'] ??
                                                      0,
                                                  amountDiskon:
                                                      controller
                                                          .komisiDetailData['data'][i]['amount_diskon'] ??
                                                      0,
                                                  persen:
                                                      controller
                                                          .komisiDetailData['data'][i]['user']?['komisi_afiliasi'] ??
                                                      0,
                                                ),
                                              ),
                                            ),
                                      ],
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
      ),
    );
  }
}

Widget buildRincianKomisi({
  required int number,
  required String name,
  required String date,
  required String price,
}) {
  return Container(
    padding: EdgeInsets.all(16.0),
    margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start, // rata kiri horizontal
      crossAxisAlignment: CrossAxisAlignment.center, // rata tengah vertikal
      children: [
        // Nomor urut
        Text(
          number.toString(),
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 12),

        // Konten utama
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.center, // biar kontennya juga tengah
            children: [
              Text(date, style: TextStyle(fontSize: 10.0)),
              SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),

        // Harga
        Text(
          price,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    ),
  );
}
