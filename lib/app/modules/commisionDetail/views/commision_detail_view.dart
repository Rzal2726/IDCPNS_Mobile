import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/searchWithButton.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/commision_detail_controller.dart';

class CommisionDetailView extends GetView<CommisionDetailController> {
  const CommisionDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // false supaya tidak auto-pop
      onPopInvoked: (didPop) {
        if (!didPop) {
          // Saat tombol back ditekan
          Get.offNamed(Routes.AFFILIATE);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "Rincian Komisi",
          onBack: () {
            Get.offNamed(Routes.AFFILIATE);
          },
        ),
        body: SafeArea(
          child: Obx(() {
            final data = controller.komisiDetailData['data'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔎 Search tetap di atas
                Padding(
                  padding: AppStyle.screenPadding,
                  child: SearchRowButton(
                    controller: controller.searchController,
                    onSearch: () {
                      controller.getRincianKomisi(
                        search: controller.searchController.text,
                      );
                    },
                    hintText: "Cari",
                  ),
                ),
                SizedBox(height: 20),

                // 📋 Isi konten
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    child:
                        (data == null || data.isEmpty)
                            ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    "assets/emptyArchiveIcon.svg",
                                    height: 150,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    "Tidak ada transaksi",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Rincian Komisi",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Expanded(
                                  child: ListView(
                                    children: [
                                      for (var i = 0; i < data.length; i++)
                                        if (data[i]['user'] != null)
                                          buildRincianKomisi(
                                            number: i + 1,
                                            name:
                                                data[i]['user_name'].toString(),
                                            date: data[i]['tanggal'] ?? '',
                                            price: formatRupiah(
                                              hitungKomisiDetail(
                                                amount: data[i]['amount'] ?? 0,
                                                amountAdmin:
                                                    data[i]['amount_admin'] ??
                                                    0,
                                                amountDiskon:
                                                    data[i]['amount_diskon'] ??
                                                    0,
                                                persen:
                                                    data[i]['user']?['komisi_afiliasi'] ??
                                                    0,
                                              ),
                                            ),
                                          ),
                                      SizedBox(height: 20),
                                      ReusablePagination(
                                        nextPage: controller.nextPage,
                                        prevPage: controller.prevPage,
                                        currentPage: controller.currentPage,
                                        totalPage: controller.totalPage,
                                        goToPage: controller.goToPage,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            );
          }),
        ),
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
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(
        color: Colors.teal, // ✅ border teal
      ),
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
