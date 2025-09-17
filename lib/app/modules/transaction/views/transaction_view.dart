import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/modules/transaction/controllers/transaction_controller.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
              // ===== OPTION BAR GANTI TAB =====
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        controller.option.map((option) {
                          final isSelected =
                              controller.selectedOption.value == option;

                          return GestureDetector(
                            onTap: () {
                              controller.selectedOption.value = option;

                              // Tentukan status untuk API
                              String status = "";
                              if (option == "Sukses") status = "SUCCESS";
                              if (option == "Menunggu Pembayaran")
                                status = "PENDING";
                              if (option == "Gagal") status = "FAILED";
                              controller.status.value = status;
                              controller.getTransaction(status: status);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    option,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.teal
                                              : Colors.grey[700],
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    height: 2,
                                    width: isSelected ? 20 : 0,
                                    color: Colors.teal,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  );
                }),
              ),

              SizedBox(height: 8),

              // ===== SEARCH =====
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller.searchController,
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
                    suffixIcon: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // Panggil API hanya saat klik ikon search
                        controller.getTransaction(
                          page: 1, // biasanya reset ke halaman 1 saat search
                          search: controller.searchController.text,
                          date: controller.startDateController.text,
                          status: controller.status.value,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          width: 38,
                          child: Icon(
                            Icons.search_rounded,
                            size: 22,
                            color: Colors.black87,
                          ),
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
                      onTap: () {
                        showTransactionFilterBottomSheet(context);
                      },
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

              // ===== LIST TRANSAKSI =====
              Expanded(
                child: Obx(() {
                  if (controller.isloading.value) {
                    return Skeletonizer(
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder:
                            (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                      ),
                    );
                  }

                  final allData = controller.transactions['data'] ?? [];
                  if (allData.isEmpty) {
                    return _buildEmptyState();
                  }

                  return Column(
                    children: [
                      _buildTransactionList(allData),
                      SizedBox(height: 20),
                      Visibility(
                        visible: controller.transactions.isNotEmpty,
                        child: ReusablePagination(
                          nextPage: controller.nextPage,
                          prevPage: controller.prevPage,
                          currentPage: controller.currentPage,
                          totalPage: controller.totalPage,
                          goToPage: controller.goToPage,
                        ),
                      ),
                    ],
                  );
                }),
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
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.INVOICE, arguments: trx['id']);
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.chevron_right_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showTransactionFilterBottomSheet(BuildContext context) {
  final controller = Get.put(TransactionController());

  final DateTime today = DateTime.now();
  controller.endDateController.text =
      "${today.day.toString().padLeft(2, '0')}/"
      "${today.month.toString().padLeft(2, '0')}/"
      "${today.year}";

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: MediaQuery.of(ctx).viewInsets,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Filter",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Tanggal Mulai
                    Text("Tanggal Mulai"),
                    SizedBox(height: 4),
                    TextField(
                      controller: controller.startDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Pilih Tanggal",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            controller.startDateController.text =
                                "${pickedDate.day.toString().padLeft(2, '0')}/"
                                "${pickedDate.month.toString().padLeft(2, '0')}/"
                                "${pickedDate.year}";
                          });
                        }
                      },
                    ),
                    SizedBox(height: 12),

                    // Tanggal Selesai (tidak bisa diedit)
                    Text("Tanggal Selesai"),
                    SizedBox(height: 4),
                    TextField(
                      controller: controller.endDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Tombol Cari
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Kirim data ke controller
                          controller.getTransaction(
                            page: controller.currentPage.value,
                            date: controller.startDateController.text,
                            status: controller.status.value,
                          );
                          print(
                            "Start: ${controller.startDateController.text}",
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text("Cari"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
