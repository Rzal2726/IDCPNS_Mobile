import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
                  Text("Checkout Paket Bimbel", style: AppStyle.styleW900),
                  SizedBox(height: 16),
                  // Bimbel Section
                  controller.bimbelData.isNotEmpty
                      ? Text(
                        controller.bimbelData['bimbel_parent']['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      : Skeletonizer(
                        enabled: true,
                        child: Text(
                          "Judul Bimbel",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  SizedBox(height: 10),
                  Row(
                    spacing: 4,
                    children: [
                      Icon(Icons.check_box, color: Colors.teal),
                      Obx(() {
                        return Container(
                          width: 240,
                          child:
                              controller.bimbelData.isNotEmpty
                                  ? Text(controller.bimbelData['name'])
                                  : Skeletonizer(
                                    enabled: true,
                                    child: Text("Judul Bimbel"),
                                  ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 10),
                  const Text(
                    "Bimbel Lainnya",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var data in controller.otherBimbelData)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                width: 300,
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header row (title + X)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data['name'] ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Obx(() {
                                          final isSelected = controller
                                              .selectedPaketPerCard
                                              .containsKey(data['id']);
                                          return Visibility(
                                            visible: isSelected,
                                            maintainSize: true,
                                            maintainAnimation: true,
                                            maintainState: true,
                                            child: GestureDetector(
                                              onTap: () {
                                                // hapus paket dari selected
                                                controller.selectedPaketPerCard
                                                    .remove(data['id']);

                                                // langsung hapus promo code dan reset amountPromo
                                                controller.promoController
                                                    .clear();
                                                controller.promoAmount.value =
                                                    0;
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                child: Icon(
                                                  Icons.cancel,
                                                  size: 20,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),

                                    SizedBox(height: 8),

                                    Column(
                                      children: [
                                        for (
                                          var i = 0;
                                          i < data['bimbel_list'].length;
                                          i++
                                        )
                                          Builder(
                                            builder: (_) {
                                              final subData =
                                                  data['bimbel_list'][i];

                                              // index paket pertama yang sudah dibeli
                                              final firstPurchasedIndex =
                                                  data['bimbel_list']
                                                      .indexWhere(
                                                        (e) =>
                                                            e['is_purchase'] ==
                                                            true,
                                                      );

                                              // skip paket yang lebih murah dari paket yang sudah dibeli
                                              if (firstPurchasedIndex != -1 &&
                                                  i < firstPurchasedIndex) {
                                                return SizedBox.shrink();
                                              }

                                              // harga yang ditampilkan dikurangi harga paket yang sudah dibeli
                                              final hargaTampil =
                                                  (firstPurchasedIndex != -1 &&
                                                          i > firstPurchasedIndex)
                                                      ? subData['harga_fix'] -
                                                          data['bimbel_list'][firstPurchasedIndex]['harga_fix']
                                                      : subData['harga_fix'];

                                              // disable jika paket sudah dibeli
                                              final isDisabled =
                                                  (firstPurchasedIndex != -1 &&
                                                      i == firstPurchasedIndex);

                                              return _buildRadioOption(
                                                subData['name'], // title
                                                subData['id'], // paketId
                                                data['id'], // parentId
                                                hargaTampil, // hargaFix
                                                controller,
                                                isDisabled:
                                                    isDisabled, // disable jika sudah dibeli
                                              );
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Paket Lainnya
                  SizedBox(height: 15),
                  Divider(height: 1),
                  SizedBox(height: 15),

                  // Metode Pembayaran
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
                          Obx(() {
                            if (controller.paymentImage.value.isEmpty) {
                              return Container(
                                width: 36,
                                height: 36,
                                child: Icon(
                                  Icons.credit_card,
                                  color: Colors.teal,
                                ),
                              );
                            } else {
                              return Container(
                                width: 50,
                                height: 50,
                                child: SvgPicture.network(
                                  controller.paymentImage.value,
                                  fit: BoxFit.contain,
                                  placeholderBuilder:
                                      (_) => Icon(
                                        Icons.credit_card,
                                        color: Colors.teal,
                                      ),
                                ),
                              );
                            }
                          }),
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
                    onTap: () => showPromoCodeBottomSheet(context),
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
                  Visibility(
                    visible: controller.promoAmount.value != 0,
                    child: Column(
                      children: [
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle, // icon ceklis bulat
                              color: Colors.green,
                              size: 20, // bisa disesuaikan
                            ),
                            SizedBox(width: 6), // jarak antara icon dan text
                            Text(
                              "Kode promo berhasil digunakan.",
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

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
                            "${formatRupiah(controller.getTotalHargaFix())}",
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
                            "${formatRupiah((controller.getTotalHargaFix() - controller.promoAmount.value))}",
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
                          controller.getTotalHargaFix() > 0
                              ? () => controller.createPayment()
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
}

// helper radio widget
Widget _buildRadioOption(
  String title,
  int paketId,
  int parentId,
  int hargaFix,
  PaymentDetailController controller, {
  bool isDisabled = false, // disable radio jika paket sudah dibeli
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Radio + Title
        Row(
          children: [
            Obx(
              () => Radio<int>(
                value: paketId,
                groupValue: controller.selectedPaketPerCard[parentId]?["id"],
                onChanged:
                    isDisabled
                        ? null
                        : (value) {
                          if (value != null) {
                            controller.pilihPaket(parentId, {
                              "id": value,
                              "harga_fix": hargaFix,
                            });
                            print(
                              "xxx ${controller.selectedPaketPerCard.toString()}",
                            );
                          }
                        },
                activeColor: Colors.teal,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 4),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),

        // Harga
        Text(
          isDisabled ? '' : formatRupiah(hargaFix),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

void showPaymentBottomSheet(BuildContext context) {
  final controller = Get.put(PaymentDetailController());
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
              : SafeArea(
                child: SingleChildScrollView(
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
                                    onTap: () {
                                      Get.back();
                                      method['code'] == "OVO"
                                          ? showPhoneNumberBottomSheet(context)
                                          : controller.paymentSelected(
                                            id: method['id'],
                                            methode: method['code'],
                                            type: data['code'],
                                          );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ],
                  ),
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
                    height: 30,
                    width: 30,
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

void showPromoCodeBottomSheet(BuildContext context) {
  final controller = Get.put(PaymentDetailController());
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
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: SingleChildScrollView(
                  padding: AppStyle.contentPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Voucher",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Get.back(),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.promoController,
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
                                controller.getApplyCode();
                                Get.back();
                              },
                              child: Text(
                                "Klaim",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
        }),
      );
    },
  );
}

void showPhoneNumberBottomSheet(BuildContext context) {
  final controller = Get.put(PaymentDetailController());
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          // Tambahkan padding di sini
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Obx(() {
            return controller.paymantListData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: SingleChildScrollView(
                    padding: AppStyle.contentPadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Nomor Telepon",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Row(
                            children: [
                              // Tambahkan Textbox untuk "+62" di sini
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "+62",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),

                              Expanded(
                                child: TextField(
                                  controller: controller.ovoController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "Kirim",
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: Colors.teal,
                                      ),
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
                                  controller.getAddOvoNumber();
                                  Get.back();
                                },
                                child: Text(
                                  "Kirim",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
          }),
        ),
      );
    },
  );
}
