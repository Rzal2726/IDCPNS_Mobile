import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
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
      appBar: secondaryAppBar("Rincian Pembayaran"),
      body: SafeArea(
        child: Obx(() {
          return RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.teal,
            onRefresh: () => controller.refresh(),
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
                    // Judul
                    Text("Checkout Paket Bimbel", style: AppStyle.style17Bold),
                    SizedBox(height: 16),
                    // Bimbel Section
                    controller.bimbelData.isNotEmpty
                        ? Text(
                          controller.bimbelData['bimbel_parent']['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : Skeletonizer(
                          enabled: true,
                          child: Text(
                            "Judul Bimbel",
                            style: TextStyle(
                              fontSize: 16,
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
                    SizedBox(height: 16),
                    Text(
                      "Bimbel Lainnya",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Column(
                      children: [
                        for (var data in controller.otherBimbelData)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
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
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      maxLines: 2,
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
                                            if (controller
                                                    .promoController
                                                    .text !=
                                                "") {
                                              controller.getApplyCode();
                                            }
                                            controller.updateBiayaAdmin(
                                              controller.biayaAdminRaw.value,
                                            );
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
                                              data['bimbel_list'].indexWhere(
                                                (e) => e['is_purchase'] == true,
                                              );

                                          // skip paket yang lebih murah dari paket pertama yang sudah dibeli
                                          if (firstPurchasedIndex != -1 &&
                                              i < firstPurchasedIndex) {
                                            return SizedBox.shrink();
                                          }

                                          // skip paket yang sudah dibeli
                                          if (subData['is_purchase'] == true) {
                                            return SizedBox.shrink();
                                          }

                                          // hitung harga tampil
                                          final hargaTampil =
                                              (firstPurchasedIndex != -1)
                                                  ? subData['harga_fix'] -
                                                      data['bimbel_list'][firstPurchasedIndex]['harga_fix']
                                                  : subData['harga_fix'];

                                          return _buildRadioOption(
                                            subData['name'], // title
                                            subData['id'], // paketId
                                            data['id'], // parentId
                                            hargaTampil, // hargaFix
                                            controller,
                                            isDisabled:
                                                false, // semua yang tampil bisa diinteraksi
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    // Paket Lainnya
                    Divider(height: 1),
                    SizedBox(height: 20),

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
                          ],
                        ),

                        SizedBox(height: 6),

                        if (controller.biayaAdmin.value != 0)
                          Column(
                            children: [
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
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      )
                                      : Text(
                                        "${formatRupiah(controller.biayaAdmin.value)}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                ],
                              ),
                              SizedBox(height: 6),
                            ],
                          ),

                        if (controller.promoAmount.value != 0)
                          Column(
                            children: [
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
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      )
                                      : Text(
                                        "${formatRupiah(controller.promoAmount.value)}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                ],
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
                            controller.isLoading.value
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
    padding: EdgeInsets.symmetric(vertical: 4),
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
                              "biayaAd ${controller.biayaAdminRaw.toString()}",
                            );
                            if (controller.promoController.text != "") {
                              controller.getApplyCode();
                            }
                            controller.updateBiayaAdmin(
                              controller.biayaAdminRaw.value,
                            );
                          }
                        },
                activeColor: Colors.teal,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: 4),
            Text(title, style: TextStyle(fontSize: 12)),
          ],
        ),

        // Harga
        Text(
          isDisabled ? '' : formatRupiah(hargaFix),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      return SafeArea(
        child: SizedBox(
          height: screenHeight * 0.5,
          child: Obx(() {
            if (controller.paymantListData.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER FIXED
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
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
                        icon: const Icon(Icons.close, color: Colors.black54),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // BAGIAN SCROLLABLE
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var data in controller.paymantListData) ...[
                          Text(
                            "${data['name']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
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
                                    margin: const EdgeInsets.only(right: 10),
                                    child: paymentItem(
                                      svgPath: method['image_url'],
                                      title: method['name'],
                                      subtitle: "Biaya Admin",
                                      adminPrice: formatRupiah(
                                        controller.calculateBiayaAdmin(
                                          method['biaya_admin'],
                                        ),
                                      ),
                                      onTap: () {
                                        Get.back();
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
                                          showPhoneNumberBottomSheet(context);
                                        } else {
                                          controller.paymentSelected(
                                            id: method['id'],
                                            methode: method['code'],
                                            type: data['code'],
                                            image: method['image_url'],
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
  required String adminPrice,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: SvgPicture.network(
                svgPath,
                fit: BoxFit.contain,
                placeholderBuilder:
                    (context) => SizedBox(
                      height: 30,
                      width: 30,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
              ),
            ),
          ),
          SizedBox(height: 8),

          // Title & subtitle pakai Expanded supaya teks panjang nggak overflow
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  adminPrice,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
      // PENTING: Tambahkan padding bottom sesuai viewInsets agar naik saat keyboard muncul
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
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
                                  inputFormatters: [UpperCaseTextFormatter()],
                                  decoration: InputDecoration(
                                    hintText:
                                        "Masukkan Kode Promo disini", // hintText juga bisa kamu bikin kapital manual
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
                );
          }),
        ),
      );
    },
  );
}

void showPhoneNumberBottomSheet(BuildContext context) {
  final controller = Get.put(PaymentDetailController());
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
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
                              onPressed: () {
                                controller.clearPaymentSelection();
                                Get.back();
                              },
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
                                    LengthLimitingTextInputFormatter(
                                      13,
                                    ), // batasi maksimal 13 digit
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
