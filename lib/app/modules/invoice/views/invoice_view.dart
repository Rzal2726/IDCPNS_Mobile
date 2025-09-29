import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';

import '../controllers/invoice_controller.dart';

import 'package:skeletonizer/skeletonizer.dart';

class InvoiceView extends GetView<InvoiceController> {
  const InvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: basicAppBarWithoutNotif("Invoice Pembelian"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Obx(() {
              var data = controller.notifData;

              bool isLoading = data.isEmpty;

              return Skeletonizer(
                enabled: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tanggal Transaksi
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Transaksi:",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          data['tanggal_kadaluarsa'] ?? "-",
                          style: TextStyle(
                            fontSize: 15, // isi sesuai ukuran yang kamu mau
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nomor Invoice:",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              data['no_order'] ?? "-",
                              style: TextStyle(
                                fontSize: 15, // isi sesuai ukuran yang kamu mau
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Status:", style: TextStyle(fontSize: 15)),
                            Text(
                              data['status'] == "PAID" ? "Sukses" : "Gagal",
                              style: TextStyle(
                                color:
                                    data['status'] == "PAID"
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Nomor Invoice
                    SizedBox(height: 4),

                    // Status
                    SizedBox(height: 16),

                    // Table Item
                    Table(
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columnWidths: {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Item",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Tanggal Kadaluarsa",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        for (var e in (data['payment_details'] as List? ?? []))
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (e["item_parent_name"] ?? "").toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (e["item_name"] != null)
                                      Text(
                                        e["item_name"] ?? "",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  style: TextStyle(fontSize: 15),
                                  controller.formatTanggal(
                                    data['tanggal_kadaluarsa'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Pembeli
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pembeli:", style: TextStyle(fontSize: 15)),
                            Text(
                              controller.box.read('name') ?? "-",
                              style: TextStyle(
                                fontSize: 15, // isi sesuai ukuran yang kamu mau
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Biaya Admin:",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              formatRupiah(data['amount_admin']) ?? "-",
                              style: TextStyle(
                                fontSize: 15, // isi sesuai ukuran yang kamu mau
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Kode Promo:", style: TextStyle(fontSize: 15)),
                            Text(
                              data['kode_promo'] ?? "-",
                              style: TextStyle(
                                fontSize: 15, // isi sesuai ukuran yang kamu mau
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Diskon:", style: TextStyle(fontSize: 15)),
                            Text(
                              data['amount_diskon'] != 0
                                  ? formatRupiah(data['amount_diskon'])
                                  : "-",
                              style: TextStyle(
                                fontSize: 15, // isi sesuai ukuran yang kamu mau
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Divider(height: 24),

                    // Total Harga
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Harga:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatRupiah(data['amount'] ?? 0),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Tombol kembali
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Get.back(),
                        child: Text(
                          "Kembali",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
