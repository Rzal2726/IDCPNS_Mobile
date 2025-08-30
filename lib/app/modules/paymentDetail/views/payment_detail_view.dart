import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/payment_detail_controller.dart';

class PaymentDetailView extends GetView<PaymentDetailController> {
  const PaymentDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Rincian Pembayaran", style: AppStyle.appBarTitle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul
              Text("Checkout Paket Bimbel", style: AppStyle.styleW900),
              SizedBox(height: 16),

              // Paket Utama
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.paketUtama.value,
                      style: AppStyle.style15Bold,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        // custom checkbox-like icon agar mirip gambar
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade600,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          controller.paketUtamaTipe.value,
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28),

              // Paket Lainnya
              Text(
                "Bimbel Lainnya",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Bimbel SKD CPNS 2025 batch 16",
                style: AppStyle.style15Bold,
              ),
              SizedBox(height: 8),
              Obx(
                () => Column(
                  children: [
                    RadioListTile<String>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: "Extended",
                      groupValue: controller.selectedPaketLainnya.value,
                      onChanged: (v) => controller.pilihPaketLainnya(v!),
                      title: Text("Extended", style: TextStyle(fontSize: 14)),
                      activeColor: Colors.teal,
                    ),
                    RadioListTile<String>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: "Extended + Platinum Zone",
                      groupValue: controller.selectedPaketLainnya.value,
                      onChanged: (v) => controller.pilihPaketLainnya(v!),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Extended + Platinum Zone",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "Rp. 50.000",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      activeColor: Colors.teal,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),
              Divider(height: 1),
              SizedBox(height: 15),

              // Metode Pembayaran
              Text(
                "Metode Pembayaran",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => paymentDialog(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.35)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        child: Icon(Icons.credit_card, color: Colors.teal),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.metodePembayaran.isEmpty
                                ? "Pilih Pembayaran"
                                : controller.metodePembayaran.value,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Kode Promo
              Text("Kode Promo", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => promoCodeDialog(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.35)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        child: Icon(Icons.discount, color: Colors.orange),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.kodePromo.isEmpty
                                ? "Gunakan Kode Promo"
                                : controller.kodePromo.value,
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12),
              SizedBox(height: 12),

              // Rincian Pesanan
              Text(
                "Rincian Pesanan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Obx(
                () => Column(
                  children: [
                    // Baris Harga
                    Row(
                      children: [
                        Expanded(
                          child: Text("Harga", style: TextStyle(fontSize: 14)),
                        ),
                        Text(
                          "Rp.${controller.harga.value}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    // Baris Total Harga (bold)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Total Harga",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          "Rp.${controller.totalHarga.value}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Tombol Bayar
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed:
                        controller.totalHarga.value > 0
                            ? () => controller.bayarSekarang()
                            : null,
                    child: Text(
                      "Bayar Sekarang",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
