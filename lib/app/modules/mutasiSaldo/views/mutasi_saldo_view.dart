import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/mutasi_saldo_controller.dart';

class MutasiSaldoView extends GetView<MutasiSaldoController> {
  const MutasiSaldoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Afiliasi", style: AppStyle.appBarTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    "9+",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
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
                    controller: controller.searchController,
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
                      suffixIcon: GestureDetector(
                        onTap: () {
                          // Panggil API saat icon search ditekan
                          controller.getMutasiSaldo(
                            search: controller.searchController.text,
                          );
                        },
                        child: Icon(Icons.search, color: Colors.black54),
                      ),
                    ),
                    onSubmitted: (value) {
                      // Panggil API saat user tekan "Enter"
                      controller.getMutasiSaldo(search: value);
                    },
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
                            "Mutasi Saldo",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child:
                                controller.mutasiSaldoData['data'] == null ||
                                        controller
                                            .mutasiSaldoData['data']
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
                                        Column(
                                          children: [
                                            for (
                                              var i = 0;
                                              i <
                                                  controller
                                                      .mutasiSaldoData['data']
                                                      .length;
                                              i++
                                            )
                                              buildbalanceTransfer(
                                                number: i + 1,
                                                date:
                                                    controller
                                                        .mutasiSaldoData['data'][i]['tanggal'] ??
                                                    '',
                                                price:
                                                    formatRupiah(
                                                      controller
                                                          .mutasiSaldoData['data'][i]['nominal'],
                                                    ) ??
                                                    'Rp0',
                                                status: _getStatus(
                                                  controller
                                                      .mutasiSaldoData['data'][i]['status'],
                                                ),
                                                statusColor: _getStatusColor(
                                                  controller
                                                      .mutasiSaldoData['data'][i]['status'],
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Visibility(
                                          visible:
                                              controller
                                                  .mutasiSaldoData
                                                  .isNotEmpty,
                                          child: ReusablePagination(
                                            nextPage: controller.nextPage,
                                            prevPage: controller.prevPage,
                                            currentPage: controller.currentPage,
                                            totalPage: controller.totalPage,
                                            goToPage: controller.goToPage,
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

Widget buildbalanceTransfer({
  required int number,
  required String date,
  required String price,
  required String status,
  required Color statusColor,
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
