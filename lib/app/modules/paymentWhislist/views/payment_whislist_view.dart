import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/payment_whislist_controller.dart';

class PaymentWhislistView extends GetView<PaymentWhislistController> {
  const PaymentWhislistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Checkout Wishlist", style: AppStyle.appBarTitle),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
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
                  Text("Wishlist", style: AppStyle.styleW900),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.wishLishData.length,
                    itemBuilder: (context, index) {
                      final item = controller.wishLishData[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: buildProductSection(
                          parentId: item['bimbel_parent_id'],
                          title:
                              item['productDetail']['name'] ??
                              item['productDetail']['formasi'],
                          selectedValue: controller.selectedPaketLainnya.value,
                          onChanged: (v) => controller.pilihPaketLainnya(v),
                          productDetail: item['productDetail'],
                          isChecked: controller.productChecked[index] ?? false,
                          // tambahin ini
                          onCheckChanged:
                              (v) => controller.toggleCheck(
                                index,
                                v ?? false,
                              ), // tambahin ini
                        ),
                      );
                    },
                  ),

                  // Paket Lainnya
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
                    onTap: () => showPaymentBottomSheet(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.35),
                        ),
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
                            child: Text(
                              controller.metodePembayaran.isEmpty
                                  ? "Pilih Pembayaran"
                                  : controller.metodePembayaran.value,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Kode Promo
                  Text(
                    "Kode Promo",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => promoCodeDialog(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.35),
                        ),
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
                            child: Text(
                              controller.kodePromo.isEmpty
                                  ? "Gunakan Kode Promo"
                                  : controller.kodePromo.value,
                              style: TextStyle(fontSize: 14),
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
                  Column(
                    children: [
                      // Baris Harga
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Harga",
                              style: TextStyle(fontSize: 14),
                            ),
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

                  SizedBox(height: 20),

                  // Tombol Bayar
                  SizedBox(
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
                ],
              ),
            ),
          );
        }),
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
}

void promoCodeDialog() {
  final TextEditingController promoController = TextEditingController();

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Voucher",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Input + Button
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: promoController,
                      decoration: InputDecoration(
                        hintText: "Cari",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(
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
                    child: Text("Klaim"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildRadioOption({
  required String value,
  required String groupValue,
  required void Function(String?) onChanged,
  required String title,
  int? price,
}) {
  return RadioListTile<String>(
    dense: true,
    contentPadding: EdgeInsets.zero,
    value: value,
    groupValue: groupValue,
    onChanged: onChanged,
    title:
        price == null
            ? Text(title, style: TextStyle(fontSize: 14))
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 14)),
                Text(
                  "Rp ${price.toString()}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
    activeColor: Colors.teal,
  );
}

Widget buildProductSection({
  required dynamic parentId,
  required String title,
  required String selectedValue,
  required void Function(String) onChanged,
  required Map<String, dynamic> productDetail,
  required bool isChecked,
  required void Function(bool?) onCheckChanged,
}) {
  final String header = parentId != null ? "Bimbel" : "Tryout";

  final List options = productDetail['is_not_purchased'] ?? [];
  final String? hargaFix = productDetail['harga_fix']?.toString();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 15),

      // Checkbox + Title
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (v) {
                  onCheckChanged(v);

                  // Reset pilihan kalau di-uncheck
                  if (v == false) {
                    onChanged("");
                  }
                },
              ),
              Text(title, style: AppStyle.style15Bold),
            ],
          ),
          if (hargaFix != null)
            Text(
              formatRupiah(int.parse(hargaFix)),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),

      // Kalau ada options
      if (options.isNotEmpty)
        Column(
          children:
              options.map<Widget>((opt) {
                final String value = opt["uuid"].toString();
                final String name = opt["name"].toString();
                final int? price = opt["final_price"];

                return RadioListTile<String>(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: value,
                  groupValue: selectedValue,
                  onChanged:
                      isChecked
                          ? (v) {
                            if (v != null) onChanged(v);
                          }
                          : null, // disable kalau uncheck
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14,
                          color: isChecked ? Colors.black : Colors.grey,
                        ),
                      ),
                      if (price != null)
                        Text(
                          formatRupiah(price),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isChecked ? Colors.black : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  activeColor: Colors.teal,
                );
              }).toList(),
        ),
    ],
  );
}

void showPaymentBottomSheet(BuildContext context) {
  final controller = Get.put(PaymentWhislistController());
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: Obx(() {
          return controller.paymantListData.isEmpty
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan judul + tombol close
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Metode Pembayaran",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.black54),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Loop kategori payment
                    for (var data in controller.paymantListData) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${data['name']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 110,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var method in data['xendit_payment_method'])
                              Container(
                                width: 140,
                                margin: EdgeInsets.only(right: 12),
                                child: paymentItem(
                                  svgPath: method['image_url'],
                                  title: method['name'],
                                  subtitle:
                                      "Biaya Admin: ${method['biaya_admin']}",
                                  onTap:
                                      () => print("${method['name']} dipilih"),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ],
                ),
              );
        }),
      );
    },
  );
}

/// Widget reusable buat item pembayaran
Widget paymentItem({
  required String svgPath,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // biar ngikut isi
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            child: SvgPicture.network(
              svgPath,
              height: 25,
              placeholderBuilder:
                  (context) => SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
            ),
          ),
          SizedBox(height: 8),
          Flexible(
            child: Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 4),
          Flexible(
            child: Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
