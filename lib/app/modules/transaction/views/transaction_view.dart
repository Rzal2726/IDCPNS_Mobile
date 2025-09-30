import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/paymentTracsactionWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/searchWithButton.dart';
import 'package:idcpns_mobile/app/Components/widgets/skeletonizerWidget.dart';
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
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: secondaryAppBar(
            "Transaksi",
            onBack: () {
              Get.offNamed(Routes.HOME, arguments: {'initialIndex': 4});
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
                      scrollDirection:
                          Axis.horizontal, // ✅ bikin scroll horizontal
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
                                  controller.getTransaction(
                                    page: controller.currentPage.value,
                                    search: "", // reset
                                    status: status,
                                    date: "", // reset
                                  );
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
                        page: 1, // reset halaman ke 1 saat search
                        search: controller.searchController.text,
                        date: controller.startDateController.text,
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
                Expanded(
                  child: Obx(() {
                    final allData = controller.transactions['data'] ?? [];

                    // default: semua data
                    List filteredData = allData;

                    if (controller.endDateController.text.isNotEmpty) {
                      final endDate = DateFormat(
                        "dd/MM/yyyy",
                      ).parse(controller.endDateController.text);

                      filteredData =
                          allData.where((item) {
                            final tanggalStr =
                                item['tanggal']; // "2025-09-25 14:38:16"
                            final tanggal = DateFormat(
                              "yyyy-MM-dd HH:mm:ss",
                            ).parse(tanggalStr);

                            // cek: tanggal <= endDate (hari terakhir juga masuk)
                            return tanggal.isBefore(
                                  endDate.add(const Duration(days: 1)),
                                ) ||
                                tanggal.isAtSameMomentAs(endDate);
                          }).toList();
                    }

                    print("xxx ${filteredData.toString()}");

                    if (filteredData.isEmpty ||
                        controller.isloading.value == true) {
                      return SkeletonListWidget<dynamic>(
                        data: [],
                        skeletonDuration: const Duration(seconds: 5),
                        skeletonCount: 5,
                        emptyMessage: "Tidak ada transaksi ditemukan",
                        emptySvgAsset: "assets/empty_transactions.svg",
                        itemBuilder: (_) => const SizedBox.shrink(),
                      );
                    }

                    return _buildTransactionList(filteredData);
                  }),
                ),
              ],
            ),
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
  final controller = Get.put(TransactionController());
  return ListView.separated(
    padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
    itemCount: filtered.length + 1, // ⬅️ +1 untuk pagination
    separatorBuilder: (_, i) => SizedBox(height: 12),
    itemBuilder: (context, i) {
      if (i == filtered.length) {
        return Column(
          children: [
            SizedBox(height: 20), // ⬅️ jarak sebelum pagination
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
      }

      final trx = filtered[i];
      return GestureDetector(
        onTap: () {
          trx['status'] == 'PENDING'
              ? showPaymentSheet(
                context,
                onCancel: () {
                  showPaymentSheet2(
                    context,
                    onCancel: () {
                      controller.deleteTransaction(id: trx['id'].toString());
                    },
                    onPay: () async {
                      try {
                        if (trx.containsKey('invoice_url') &&
                            trx['invoice_url'] != null) {
                          final String url = trx['invoice_url'];
                          final uri = Uri.parse(url);

                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            debugPrint("Tidak bisa buka link: $url");
                          }
                        }
                      } catch (e) {
                        debugPrint("Error saat buka link: $e");
                      }

                      // Tetap lanjut ke halaman checkout
                      Get.offNamed(
                        Routes.PAYMENT_CHECKOUT,
                        arguments: [
                          trx['payment_id'],
                          trx['tanggal_kadaluarsa'],
                        ],
                      );
                    },
                  );
                },
                onPay: () async {
                  try {
                    if (trx.containsKey('invoice_url') &&
                        trx['invoice_url'] != null) {
                      final String url = trx['invoice_url'];
                      final uri = Uri.parse(url);

                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        debugPrint("Tidak bisa buka link: $url");
                      }
                    }
                  } catch (e) {
                    debugPrint("Error saat buka link: $e");
                  }
                  print("ccx ${trx['id'].toString()}");
                  // Tetap lanjut ke halaman checkout
                  Get.offNamed(
                    Routes.PAYMENT_CHECKOUT,
                    arguments: [trx['payment_id'], trx['tanggal_kadaluarsa']],
                  );
                },
              )
              : Get.toNamed(Routes.INVOICE, arguments: trx['id']);
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
                              trx['status'] == 'PAID'
                                  ? Colors.green
                                  : (trx['status'] == 'PENDING'
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

                    // Tanggal Selesai
                    Text("Tanggal Selesai"),
                    SizedBox(height: 4),
                    TextField(
                      controller: controller.endDateController,
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
                        // Ambil nilai tanggal mulai
                        DateTime? startDate;
                        if (controller.startDateController.text.isNotEmpty) {
                          List<String> parts = controller
                              .startDateController
                              .text
                              .split("/");
                          startDate = DateTime(
                            int.parse(parts[2]), // year
                            int.parse(parts[1]), // month
                            int.parse(parts[0]), // day
                          );
                        }

                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate:
                              startDate ??
                              DateTime(2000), // ⬅️ minimal = tanggal mulai
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            controller.endDateController.text =
                                "${pickedDate.day.toString().padLeft(2, '0')}/"
                                "${pickedDate.month.toString().padLeft(2, '0')}/"
                                "${pickedDate.year}";
                          });
                        }

                        print("xxx ${controller.endDateController.text}");
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
                              final today = DateTime.now();
                              controller.endDateController.text =
                                  "${today.day.toString().padLeft(2, '0')}/"
                                  "${today.month.toString().padLeft(2, '0')}/"
                                  "${today.year}";
                              controller.getTransaction(
                                page: controller.currentPage.value,
                                date:
                                    controller
                                        .startDateController
                                        .text, // akan kosong
                                status: controller.status.value,
                              );
                              Navigator.pop(context); // tutup bottom sheet
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
