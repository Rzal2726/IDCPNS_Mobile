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

                // 📋 Isi konten (scroll + refresh hanya di bagian list)
                Expanded(
                  child: RefreshIndicator(
                    color: Colors.teal,
                    backgroundColor: Colors.white,
                    onRefresh: () => controller.refresh(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child:
                          data != null && data.isNotEmpty
                              ? SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
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
                                    SizedBox(height: 20),
                                    // Daftar komisi
                                    Column(
                                      children: List.generate(data.length, (i) {
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
                                      }),
                                    ),
                                    SizedBox(height: 20),
                                    // Pagination
                                    ReusablePagination(
                                      nextPage: controller.nextPage,
                                      prevPage: controller.prevPage,
                                      currentPage: controller.currentPage,
                                      totalPage: controller.totalPage,
                                      goToPage: controller.goToPage,
                                    ),
                                  ],
                                ),
                              )
                              // 💤 Empty state
                              : SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: Center(
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
                                  ),
                                ),
                              ),
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
        Row(
          spacing: 15,
          children: [
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
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
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
