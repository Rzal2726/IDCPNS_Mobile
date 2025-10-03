import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/searchWithButton.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/mutasi_saldo_controller.dart';

class MutasiSaldoView extends GetView<MutasiSaldoController> {
  const MutasiSaldoView({super.key});
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
          "Mutasi Saldo",
          onBack: () {
            Get.offNamed(Routes.AFFILIATE);
          },
        ),
        body: SafeArea(
          child: Obx(() {
            final data = controller.mutasiSaldoData['data'];

            return Padding(
              padding: AppStyle.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔎 Search box
                  SearchRowButton(
                    controller: controller.searchController,
                    onSearch: () {
                      controller.getMutasiSaldo(
                        search: controller.searchController.text,
                      );
                    },
                    hintText: "Cari",
                  ),

                  SizedBox(height: 30),

                  Expanded(
                    child:
                        data == null
                            // ⏳ Skeletonizer
                            ? ListView.builder(
                              itemCount: 3,
                              itemBuilder:
                                  (context, index) => Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
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
                                          width: double.infinity,
                                          color: Colors.grey.shade300,
                                        ),
                                        SizedBox(height: 7),
                                        Container(
                                          height: 16,
                                          width: double.infinity,
                                          color: Colors.grey.shade300,
                                        ),
                                        SizedBox(height: 7),
                                        Container(
                                          height: 14,
                                          width: double.infinity,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                  ),
                            )
                            : data.isNotEmpty
                            // ✅ Data tersedia
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
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: buildbalanceTransfer(
                                          number: i + 1,
                                          date: item['tanggal'] ?? '',
                                          price:
                                              formatRupiah(item['nominal']) ??
                                              'Rp0',
                                          status: _getStatus(item['status']),
                                          statusColor: _getStatusColor(
                                            item['status'],
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
                            // ❌ Data kosong
                            : Center(
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
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

Widget buildbalanceTransfer({
  required int number,
  required String date,
  required String price,
  required String status,
  required Color statusColor,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          number.toString(),
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date, style: TextStyle(fontSize: 10.0)),
            Text(
              price,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

Color _getStatusColor(String? status) {
  switch (status?.toUpperCase()) {
    case 'PAID':
      return Colors.green;
    case 'PENDING':
      return Colors.orange;
    default:
      return Colors.red;
  }
}

String _getStatus(String? status) {
  switch (status?.toUpperCase()) {
    case 'PAID':
      return "Berhasil";
    case 'PENDING':
      return "Sedang Diperoses";
    default:
      return "Gagal";
  }
}
