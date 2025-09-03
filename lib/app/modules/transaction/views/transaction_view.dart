import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/modules/transaction/controllers/transaction_controller.dart';

class TransactionView extends GetView<TransactionController> {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Transaksi',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.notifications_rounded, color: Colors.teal),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '9+',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== TAB BAR =====
              Material(
                color: Colors.white,
                child: TabBar(
                  labelColor: Colors.teal,
                  unselectedLabelColor: Colors.black87,
                  indicatorColor: Colors.teal,
                  indicatorWeight: 3,
                  labelStyle: TextStyle(fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(text: 'Semua'),
                    Tab(text: 'Sukses'),
                    Tab(text: 'Menunggu Pembayaran'),
                  ],
                ),
              ),
              SizedBox(height: 8),

              // ===== SEARCH =====
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (q) {
                    controller.update();
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.teal, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.teal, width: 1.6),
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        width: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.search_rounded,
                          size: 22,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    suffixIconConstraints: BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // ===== HEADER RIWAYAT + FILTER =====
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Riwayat Transaksi',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            'Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),

              // ===== LIST PER TAB =====
              Expanded(
                child: TabBarView(
                  children: [
                    // Semua
                    Obx(() {
                      final allData = controller.transactions['data'] ?? [];
                      final filtered = allData;
                      print("asd ${controller.transactions.toString()}");
                      if (filtered.isEmpty) {
                        return _buildEmptyState();
                      }
                      return _buildTransactionList(filtered);
                    }),

                    // Sukses
                    Obx(() {
                      final allData = controller.transactions['data'] ?? [];
                      final filtered =
                          allData
                              .where((t) => t['status'] == 'SUCCESS')
                              .toList();
                      if (filtered.isEmpty) {
                        return _buildEmptyState();
                      }
                      return _buildTransactionList(filtered);
                    }),

                    // Menunggu Pembayaran
                    Obx(() {
                      final allData = controller.transactions['data'] ?? [];
                      final filtered =
                          allData
                              .where((t) => t['status'] == 'PENDING')
                              .toList();
                      if (filtered.isEmpty) {
                        return _buildEmptyState();
                      }
                      return _buildTransactionList(filtered);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.receipt_long, size: 60, color: Colors.grey),
        SizedBox(height: 12),
        Text(
          "Tidak ada transaksi",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildTransactionList(List<dynamic> filtered) {
  return ListView.separated(
    padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
    itemCount: filtered.length,
    separatorBuilder: (_, __) => SizedBox(height: 12),
    itemBuilder: (_, i) {
      final trx = filtered[i];
      print("sddd ${trx['payment_details'][0]['item_parent_name'].toString()}");
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14, 12, 12, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            trx['status'] == 'PAID'
                                ? Colors.green
                                : (trx['status'] == ('PENDING')
                                    ? Colors.amber
                                    : Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        trx['status']?.toString().toUpperCase() == 'PAID'
                            ? "Sukses"
                            : trx['status'] == 'PENDING'
                            ? "Menunggu Pembayaran"
                            : "Gagal",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      trx['no_order'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      (trx['payment_details'] != null &&
                              trx['payment_details'].isNotEmpty)
                          ? (trx['payment_details'][0]['item_parent_name'] ??
                              trx['payment_details'][0]['item_name'] ??
                              "-")
                          : "-",
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: 2),
                    Text(
                      '${trx['tanggal']} - ${formatRupiah(trx['amount'])}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.teal,
                child: Icon(Icons.chevron_right_rounded, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    },
  );
}
