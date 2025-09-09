import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
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
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildPagination()],
          ),
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

Widget _buildPagination() {
  final controller = Get.put(MutasiSaldoController());

  return Obx(() {
    int current = controller.currentPage.value;
    int total = controller.totalPage.value;

    List<int> pagesToShow = [];
    pagesToShow.add(1);
    if (current - 1 > 1) pagesToShow.add(current - 1);
    if (current != 1 && current != total) pagesToShow.add(current);
    if (current + 1 < total) pagesToShow.add(current + 1);
    if (total > 1) pagesToShow.add(total);
    pagesToShow = pagesToShow.toSet().toList()..sort();

    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: current > 1 ? () => controller.goToPage(1) : null,
              icon: Icon(Icons.first_page),
              color: current > 1 ? Colors.teal : Colors.grey,
              iconSize: 28,
              padding: EdgeInsets.symmetric(horizontal: 4),
            ),
            IconButton(
              onPressed: current > 1 ? controller.prevPage : null,
              icon: Icon(Icons.chevron_left),
              color: current > 1 ? Colors.teal : Colors.grey,
              iconSize: 28,
              padding: EdgeInsets.symmetric(horizontal: 4),
            ),

            ...pagesToShow.map((page) {
              bool isActive = page == current;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                child: GestureDetector(
                  onTap: () => controller.goToPage(page),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: isActive ? 14 : 10,
                      vertical: isActive ? 8 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.teal.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive ? Colors.teal : Colors.grey.shade300,
                        width: isActive ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      '$page',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.teal : Colors.black,
                        fontSize:
                            isActive
                                ? 16
                                : 14, // font lebih besar untuk page aktif
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),

            IconButton(
              onPressed: current < total ? controller.nextPage : null,
              icon: Icon(Icons.chevron_right),
              color: current < total ? Colors.teal : Colors.grey,
              iconSize: 28,
              padding: EdgeInsets.symmetric(horizontal: 4),
            ),
            IconButton(
              onPressed:
                  current < total ? () => controller.goToPage(total) : null,
              icon: Icon(Icons.last_page),
              color: current < total ? Colors.teal : Colors.grey,
              iconSize: 28,
              padding: EdgeInsets.symmetric(horizontal: 4),
            ),
          ],
        ),
      ),
    );
  });
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
