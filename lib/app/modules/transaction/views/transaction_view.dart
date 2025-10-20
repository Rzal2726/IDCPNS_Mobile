import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/emptyDataWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/paymentTracsactionWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/searchWithButton.dart';
import 'package:idcpns_mobile/app/Components/widgets/skeletonizerWidget.dart';
import 'package:idcpns_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:idcpns_mobile/app/modules/transaction/controllers/transaction_controller.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionView extends GetView<TransactionController> {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: PopScope(
        canPop: false, // false = cegah pop otomatis
        onPopInvoked: (didPop) async {
          if (didPop) return;
          Get.offNamed(Routes.HOME, arguments: {'initialIndex': 4});
          // (Get.find<HomeController>()).currentIndex.value = 4;
        },
        child: Obx(() {
          final allData = controller.transactions['data'] ?? [];
          final isLoading = controller.isloading.value;
          final isEmpty = !isLoading && allData.isEmpty;

          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: !isEmpty,
            appBar: secondaryAppBar(
              "Transaksi",
              onBack: () {
                Get.offNamed(Routes.HOME, arguments: {'initialIndex': 4});
                // (Get.find<HomeController>()).currentIndex.value = 4;
              },
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== OPTION BAR GANTI TAB =====
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Obx(() {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              controller.option.map((option) {
                                final isSelected =
                                    controller.selectedOption.value == option;

                                return GestureDetector(
                                  onTap: () {
                                    controller.isloading.value = true;
                                    controller.selectedOption.value = option;

                                    // Tentukan status untuk API
                                    String status = "";
                                    if (option == "Sukses") status = "PAID";
                                    if (option == "Menunggu Pembayaran")
                                      status = "PENDING";
                                    if (option == "Gagal") status = "FAILED";

                                    controller.status.value = status;

                                    // Reset field lainnya ke default sebelum fetch
                                    controller.currentPage.value = 1;
                                    controller.searchController.clear();
                                    controller.startDateController.clear();

                                    // Panggil API hanya dengan status
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
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 8),

                  // ===== SEARCH =====
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SearchRowButton(
                      controller: controller.searchController,
                      hintText: 'Cari',
                      onSearch: () {
                        controller.getTransaction(
                          search: controller.searchController.text,
                          date: controller.startDateController.text,
                          endDate: controller.endDateController.text,
                          status: controller.status.value,
                        );
                      },
                      onReset: () {
                        controller.searchController.clear();
                        controller.getTransaction(
                          search: "",
                          date: controller.startDateController.text,
                          endDate: controller.endDateController.text,
                          status: controller.status.value,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 12),

                  // ===== HEADER RIWAYAT + FILTER =====
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            showTransactionFilterBottomSheet(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Filter',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: Colors.teal,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),

                  // ===== LIST TRANSAKSI =====
                  Expanded(child: _buildTransactionList(context, allData)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

Widget _buildTransactionList(
  BuildContext context,
  List<dynamic>? filteredData,
) {
  final controller = Get.put(TransactionController());
  final list = filteredData ?? [];

  return SafeArea(
    child: Builder(
      builder: (_) {
        if (controller.isloading.value) {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                child: Skeletonizer(
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          if (list.isEmpty) {
            return EmptyStateWidget(message: 'Tidak ada transaksi ditemukan');
          } else {
            return RefreshIndicator(
              color: Colors.teal,
              backgroundColor: Colors.white,
              onRefresh: controller.refresh,
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: list.length + 1,
                itemBuilder: (context, i) {
                  if (i == list.length) {
                    return Visibility(
                      visible: controller.transactions.isNotEmpty,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: ReusablePagination(
                            nextPage: controller.nextPage,
                            prevPage: controller.prevPage,
                            currentPage: controller.currentPage,
                            totalPage: controller.totalPage,
                            goToPage: controller.goToPage,
                          ),
                        ),
                      ),
                    );
                  }

                  final trx = list[i];
                  final status = trx['status']?.toString().toUpperCase();
                  final isPaid = status == 'PAID';
                  final isPending = status == 'PENDING';

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () async {
                        if (isPending) {
                          showPaymentSheet(
                            context,
                            onCancel: () {
                              showPaymentSheet2(
                                context,
                                onCancel:
                                    () => controller.deleteTransaction(
                                      id: trx['id'].toString(),
                                    ),
                                onPay: () => _openInvoice(trx),
                              );
                            },
                            onPay: () => _openInvoice(trx),
                          );
                        } else {
                          Get.toNamed(Routes.INVOICE, arguments: trx['id']);
                        }
                      },
                      child: Container(
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
                                            isPaid
                                                ? Colors.green
                                                : (isPending
                                                    ? Colors.amber
                                                    : Colors.red),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        isPaid
                                            ? "Sukses"
                                            : isPending
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
                                      trx['no_order'] ?? "-",
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
                                      '${trx['tanggal'] ?? "-"} - ${formatRupiah(trx['amount'] ?? 0)}',
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
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }
      },
    ),
  );
}

// 🔹 Helper: buka invoice URL dan arahkan ke halaman checkout
Future<void> _openInvoice(Map<String, dynamic> trx) async {
  try {
    if (trx.containsKey('invoice_url') && trx['invoice_url'] != null) {
      final String url = trx['invoice_url'];
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Tidak bisa buka link: $url");
      }
    }
  } catch (e) {
    debugPrint("Error saat buka link: $e");
  }

  Get.offNamed(
    Routes.PAYMENT_CHECKOUT,
    arguments: [trx['payment_id'], trx['tanggal_kadaluarsa']],
  );
}

void showTransactionFilterBottomSheet(BuildContext context) {
  final controller = Get.put(TransactionController());

  // final DateTime today = DateTime.now();
  // controller.endDateController.text =
  //     "${today.day.toString().padLeft(2, '0')}/"
  //     "${today.month.toString().padLeft(2, '0')}/"
  //     "${today.year}";

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
                            //
                            // controller.endDateController.text =
                            //     "${DateTime.now().day.toString().padLeft(2, '0')}/"
                            //     "${DateTime.now().month.toString().padLeft(2, '0')}/"
                            //     "${DateTime.now().year}";
                            // // atau kalau mau kosong aja:
                            controller.endDateController.clear();
                          });
                        }
                      },
                    ),

                    SizedBox(height: 12),

                    // Tanggal Selesai
                    Text("Tanggal Selesai"),
                    SizedBox(height: 4),
                    TextField(
                      controller: controller.endDateController,
                      readOnly: true,
                      enabled: controller.startDateController.text.isNotEmpty,
                      decoration: InputDecoration(
                        hintText:
                            controller.startDateController.text.isEmpty
                                ? "Pilih tanggal mulai dahulu"
                                : "Pilih Tanggal",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onTap: () async {
                        if (controller.startDateController.text.isEmpty) return;

                        // Ambil tanggal mulai
                        final parts = controller.startDateController.text.split(
                          "/",
                        );
                        final startDate = DateTime(
                          int.parse(parts[2]),
                          int.parse(parts[1]),
                          int.parse(parts[0]),
                        );

                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: startDate,
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          controller.endDateController.text =
                              "${pickedDate.day.toString().padLeft(2, '0')}/"
                              "${pickedDate.month.toString().padLeft(2, '0')}/"
                              "${pickedDate.year}";
                        }
                      },
                    ),

                    SizedBox(height: 16),

                    // Row tombol Reset + Cari
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.startDateController.clear();
                              controller.endDateController.clear();

                              controller.getTransaction(
                                search: controller.searchController.text,
                                page: controller.currentPage.value,
                                date: "",
                                endDate: "",
                                status: controller.status.value,
                              );

                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.teal),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              "Reset",
                              style: TextStyle(color: Colors.teal),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              controller.getDate();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text("Cari"),
                          ),
                        ),
                      ],
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
