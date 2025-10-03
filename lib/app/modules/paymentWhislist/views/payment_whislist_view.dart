import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/modules/paymentDetail/controllers/payment_detail_controller.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
          // Pisahin data
          final listBimbel =
              controller.wishLishData
                  .where((e) => e['bimbel_parent_id'] != null)
                  .toList();
          final listTryout =
              controller.wishLishData
                  .where((e) => e['bimbel_parent_id'] == null)
                  .toList();

          return Skeletonizer(
            enabled:
                controller.isLoading.value ==
                true, // true saat loading, false kalau sudah ada data
            child: SingleChildScrollView(
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
                    Text("Checkout Paket Wishlist", style: AppStyle.styleW900),
                    SizedBox(height: 10),

                    // SECTION BIMBEL
                    if (listBimbel.isNotEmpty) ...[
                      Text(
                        "Paket Bimbel",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Column(
                        children: [
                          for (var data in listBimbel)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // HEADER
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            data['productDetail']?['name'] ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.visible,
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
                                                controller.selectedPaketPerCard
                                                    .remove(data['id']);
                                                if (controller
                                                            .promoController
                                                            .text !=
                                                        "" &&
                                                    controller
                                                            .getTotalHargaFix() !=
                                                        0) {
                                                  controller.getApplyCode();
                                                }

                                                controller.updateBiayaAdmin(
                                                  controller
                                                      .biayaAdminRaw
                                                      .value,
                                                );
                                              },
                                              child: Icon(
                                                Icons.cancel,
                                                size: 20,
                                                color: Colors.red,
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                    SizedBox(height: 8),

                                    // LIST PAKET
                                    Column(
                                      children: [
                                        for (var subData
                                            in (data['productDetail']?['is_not_purchased'] ??
                                                []))
                                          _buildRadioOption(
                                            subData['name'],
                                            subData['id'],
                                            data['id'],
                                            subData['final_price'],
                                            true,
                                            controller,
                                            type: "bimbel",
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],

                    // SECTION TRYOUT
                    if (listTryout.isNotEmpty) ...[
                      Text(
                        "Paket Tryout",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: [
                          for (var data in listTryout)
                            Container(
                              padding: EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // HEADER

                                  // GANTI RADIO → CHECKBOX
                                  Obx(() {
                                    final isSelected = controller
                                        .selectedPaketPerCard
                                        .containsKey(data['id']);

                                    // ✅ Auto-centang kalau belum ada yang dipilih

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          // <-- ini supaya text bisa wrap
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: isSelected,
                                                activeColor: Colors.teal,
                                                onChanged: (value) {
                                                  if (value == true) {
                                                    controller.pilihPaket(
                                                      data['id'],
                                                      {
                                                        "type": "tryout",
                                                        "id":
                                                            data['productDetail']?['id'],
                                                        "harga_fix":
                                                            data['productDetail']?['harga_fix'],
                                                      },
                                                    );
                                                  } else {
                                                    controller
                                                        .selectedPaketPerCard
                                                        .remove(data['id']);
                                                  }
                                                  if (controller
                                                              .promoController
                                                              .text !=
                                                          "" &&
                                                      controller
                                                              .getTotalHargaFix() !=
                                                          0) {
                                                    controller.getApplyCode();
                                                  }

                                                  controller.updateBiayaAdmin(
                                                    controller
                                                        .biayaAdminRaw
                                                        .value,
                                                  );
                                                  print(
                                                    "ccc ${controller.promoAmount.value}",
                                                  );
                                                },
                                              ),
                                              Expanded(
                                                // <-- ini juga supaya text wrap
                                                child: Text(
                                                  '${data['productDetail']?['formasi'] ?? ''}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                  softWrap: true,
                                                  maxLines:
                                                      2, // maksimal 2 baris
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          formatRupiah(
                                            data['productDetail']?['harga_fix'],
                                          ),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],

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
                            Obx(() {
                              if (controller.paymentImage.value.isEmpty) {
                                return Icon(
                                  Icons.credit_card,
                                  color: Colors.teal,
                                  size: 36,
                                );
                              } else {
                                return SizedBox(
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
                                controller.ovoNumber.value.isNotEmpty
                                    ? controller.ovoNumber.value
                                    : controller
                                        .metodePembayaran
                                        .value
                                        .isNotEmpty
                                    ? controller.metodePembayaran.value
                                    : "Pilih Pembayaran",
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
                      onTap:
                          controller.kodePromo.value.isNotEmpty
                              ? null
                              : () => showPromoCodeBottomSheet(context),
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
                            controller.kodePromo.value.isNotEmpty
                                ? GestureDetector(
                                  onTap: () {
                                    controller.promoController.clear();
                                    controller.kodePromo.value = '';
                                    controller.promoAmount.value = 0;
                                  },
                                  child: Icon(Icons.close),
                                )
                                : Icon(Icons.chevron_right),
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
                            controller.isLoadingHarga.value
                                ? Container(
                                  width: 60,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )
                                : Text(
                                  "${formatRupiah(controller.getTotalHargaFix())}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            SizedBox(height: 6),
                          ],
                        ),

                        if (controller.biayaAdmin.value != 0)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Biaya admin",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              controller.isLoadingHarga.value
                                  ? Container(
                                    width: 60,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  )
                                  : Text(
                                    "${formatRupiah(controller.biayaAdmin.value)}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              SizedBox(height: 6),
                            ],
                          ),

                        if (controller.promoAmount.value != 0)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Diskon",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              controller.isLoadingHarga.value
                                  ? Container(
                                    width: 60,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  )
                                  : Text(
                                    "${formatRupiah(controller.promoAmount.value)}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              SizedBox(height: 6),
                            ],
                          ),

                        // Total Harga
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Total Harga",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            controller.isLoadingHarga.value
                                ? Container(
                                  width: 60,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )
                                : Text(
                                  "${formatRupiah(controller.getTotalHargaFix() + controller.biayaAdmin.value - controller.promoAmount.value)}",
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
                            controller.isLoadingButton.value
                                ? null // disable tombol kalau lagi loading
                                : controller.getTotalHargaFix() > 0 &&
                                    controller.paymentMethodId.value != 0
                                ? () => controller.createPayment()
                                : null,
                        child:
                            controller.isLoading.value
                                ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    backgroundColor: Colors.teal.shade100,
                                  ),
                                )
                                : Text(
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
            ),
          );
        }),
      ),
    );
  }
}

Widget _buildRadioOption(
  String title,
  int paketId,
  int parentId,
  int hargaFix,
  bool isBimbel,
  PaymentWhislistController controller, {
  String type = "tryout", // default type
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(
              () => Radio<int>(
                value: paketId, // ID paket dari subData['id']
                groupValue: controller.selectedPaketPerCard[parentId]?["id"],
                onChanged: (value) {
                  if (value != null) {
                    controller.pilihPaket(parentId, {
                      "type": type, // simpan type
                      "id": value, // id paket
                      "harga_fix": hargaFix,
                    });
                    if (controller.promoController.text != "" &&
                        controller.getTotalHargaFix() != 0) {
                      controller.getApplyCode();
                    }

                    controller.updateBiayaAdmin(controller.biayaAdminRaw.value);
                  }
                },
                activeColor: Colors.teal,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            Text(title, style: TextStyle(fontSize: 12)),
          ],
        ),
        Text(
          formatRupiah(hargaFix),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    ),
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
      final screenHeight = MediaQuery.of(context).size.height;
      return SafeArea(
        child: SizedBox(
          height: screenHeight * 0.5, // 1/2 dari tinggi layar
          child: Obx(() {
            return controller.paymantListData.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Metode Pembayaran",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black54,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // KONTEN (yang bisa discroll)
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var data in controller.paymantListData) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${data['name']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 180,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    for (var method
                                        in data['xendit_payment_method'])
                                      Container(
                                        width: 160,
                                        margin: EdgeInsets.only(right: 12),
                                        child: paymentItem(
                                          svgPath: method['image_url'],
                                          title: method['name'],
                                          subtitle:
                                              "Biaya Admin: ${formatRupiah(controller.calculateBiayaAdmin(method['biaya_admin']))}",
                                          onTap: () {
                                            Get.back();
                                            print(
                                              "xxxv ${method['biaya_admin'].toString()}",
                                            );
                                            controller.updateBiayaAdmin(
                                              method['biaya_admin'],
                                            );
                                            controller.biayaAdminRaw.value =
                                                method['biaya_admin'];
                                            controller.ovoNumber.value = "";
                                            controller.ovoController.clear();
                                            controller.paymentMethod.value =
                                                method['code'];
                                            controller.paymentMethodId.value =
                                                method['id'];
                                            controller.paymentImage.value =
                                                method['image_url'];
                                            controller.paymentType.value =
                                                data['code'];
                                            controller
                                                .metodePembayaran
                                                .value = (method['code'] ?? '')
                                                .replaceAll('_', ' ');
                                            if (method['code'] == "OVO") {
                                              showPhoneNumberBottomSheet(
                                                context,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
          }),
        ),
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
            width: 160,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: SvgPicture.network(
                      svgPath,
                      fit: BoxFit.contain,
                      placeholderBuilder:
                          (context) => const SizedBox(
                            height: 30,
                            width: 30,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Standarkan tinggi title
                SizedBox(
                  height: 36, // misal cukup untuk 2 baris
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),

                // Standarkan tinggi subtitle
                SizedBox(
                  height: 30, // misal cukup untuk 2 baris
                  child: Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context)
                          .viewInsets
                          .bottom, // ini bikin konten naik saat keyboard muncul
                ),
                child: SizedBox(
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
                                  inputFormatters: [UpperCaseTextFormatter()],
                                  decoration: InputDecoration(
                                    hintText:
                                        "CARI", // hintText juga bisa kamu bikin kapital manual
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
                ),
              );
        }),
      );
    },
  );
}

void showPhoneNumberBottomSheet(BuildContext context) {
  final controller = Get.put(PaymentWhislistController());
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    isDismissible: false,
    enableDrag: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
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
                              onPressed: () {
                                controller.clearPaymentSelection();
                                Get.back();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
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
