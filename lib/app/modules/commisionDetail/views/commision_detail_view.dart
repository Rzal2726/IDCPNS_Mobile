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
                        data != null && data.isNotEmpty
                            ? Column(
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
                                  child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, i) {
                                      var item = data[i];
                                      if (item['user'] == null)
                                        return SizedBox.shrink();

                                      return buildRincianKomisi(
                                        number: i + 1,
                                        name: item['user_name'].toString(),
                                        date: item['tanggal'] ?? '',
                                        price: formatRupiah(
                                          hitungKomisiDetail(
                                            amount: item['amount'] ?? 0,
                                            amountAdmin:
                                                item['amount_admin'] ?? 0,
                                            amountDiskon:
                                                item['amount_diskon'] ?? 0,
                                            persen:
                                                item['user']?['komisi_afiliasi'] ??
                                                0,
                                          ),
                                        ),
                                      );
                                    },
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
                            )
                            : FutureBuilder(
                              future: Future.delayed(Duration(seconds: 5)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  // Skeleton selama 5 detik
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 3,
                                    itemBuilder:
                                        (context, index) => Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8.0,
                                            horizontal: 16.0,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 20,
                                                  width: 100,
                                                  color: Colors.grey.shade300,
                                                ),
                                                SizedBox(height: 7),
                                                Container(
                                                  height: 16,
                                                  width: 160,
                                                  color: Colors.grey.shade300,
                                                ),
                                                SizedBox(height: 7),
                                                Container(
                                                  height: 14,
                                                  width: 120,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  );
                                } else {
                                  // Data tetap kosong → tampil empty message
                                  return Center(
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
                                  );
                                }
                              },
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
