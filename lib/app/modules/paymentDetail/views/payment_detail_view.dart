import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/payment_detail_controller.dart';

class PaymentDetailView extends GetView<PaymentDetailController> {
  const PaymentDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rincian Pembayaran"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Checkout Paket Bimbel",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 12),

            // Paket Utama
            Obx(
              () => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  controller.paketUtama.value,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(controller.paketUtamaTipe.value),
                leading: Icon(Icons.check_box, color: Colors.teal),
              ),
            ),
            Divider(),

            // Paket Lainnya
            Text(
              "Bimbel Lainnya",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Column(
                children: [
                  RadioListTile<String>(
                    value: "Extended",
                    groupValue: controller.selectedPaketLainnya.value,
                    onChanged: (v) => controller.pilihPaketLainnya(v!),
                    title: Text("Extended"),
                  ),
                  RadioListTile<String>(
                    value: "Extended + Platinum Zone",
                    groupValue: controller.selectedPaketLainnya.value,
                    onChanged: (v) => controller.pilihPaketLainnya(v!),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Extended + Platinum Zone"),
                        Text(
                          "Rp. 50.000",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),

            // Metode Pembayaran
            Text(
              "Metode Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            GestureDetector(
              onTap: () => paymentDialog(),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.teal),
                    SizedBox(width: 8),
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.metodePembayaran.isEmpty
                              ? "Pilih Pembayaran"
                              : controller.metodePembayaran.value,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            Divider(),

            // Kode Promo
            Text("Kode Promo", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            GestureDetector(
              onTap: () => promoCodeDialog(),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.discount, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.kodePromo.isEmpty
                              ? "Gunakan Kode Promo"
                              : controller.kodePromo.value,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            Divider(),

            // Rincian Pesanan
            Text(
              "Rincian Pesanan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Obx(
              () => Column(
                children: [
                  _rowItem("Harga", "Rp.${controller.harga.value}"),
                  SizedBox(height: 4),
                  _rowItem(
                    "Total Harga",
                    "Rp.${controller.totalHarga.value}",
                    bold: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    controller.totalHarga.value > 0
                        ? controller.bayarSekarang
                        : null, // null = button disable
                child: Text("Bayar Sekarang"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rowItem(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void paymentDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Metode Pembayaran",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Virtual Account
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Virtual Account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _metodeItem(Icons.account_balance, "Bank A"),
                  _metodeItem(Icons.account_balance, "Bank B"),
                  _metodeItem(Icons.account_balance, "Bank C"),
                ],
              ),

              const SizedBox(height: 16),

              // E-Wallet
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "E-Wallet",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _metodeItem(Icons.wallet, "OVO"),
                  _metodeItem(Icons.wallet, "Dana"),
                  _metodeItem(Icons.wallet, "ShopeePay"),
                ],
              ),

              const SizedBox(height: 16),

              // QR
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "QR Payments",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [_metodeItem(Icons.qr_code, "QRIS")],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text("Tutup"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metodeItem(IconData icon, String label) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: Colors.blue),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

void promoCodeDialog() {
  final TextEditingController promoController = TextEditingController();

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Voucher",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Input + Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: promoController,
                    decoration: InputDecoration(
                      hintText: "Cari",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Colors.teal),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () {
                    String kode = promoController.text;
                    // TODO: logika klaim voucher
                    Get.back(); // tutup dialog
                    Get.snackbar("Voucher", "Kode $kode berhasil diklaim!");
                  },
                  child: const Text("Klaim"),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
