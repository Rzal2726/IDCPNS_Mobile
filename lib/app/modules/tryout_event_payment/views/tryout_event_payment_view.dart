import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/tryout_event_payment_controller.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import 'package:flutter/services.dart';

class TryoutEventPaymentView extends GetView<TryoutEventPaymentController> {
  const TryoutEventPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar("Rincian Pembayaran"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    const Text(
                      "Checkout Event Tryout",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.check_box, color: Colors.teal),
                        Container(
                          width: 240,
                          child: Obx(
                            () =>
                                controller.dataTryout['name'] != null
                                    ? Text(controller.dataTryout['name'])
                                    : Skeletonizer(
                                      enabled: true,
                                      child: Text("Judul Tryout"),
                                    ),
                          ),
                        ),
                      ],
                    ),

                    const Text(
                      "Metode Pembayaran",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(
                      () => InkWell(
                        onTap:
                            () => showModalBottomSheet(
                              barrierLabel: "Metode Pembayaran",
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (context) {
                                return _metodePembayaran(context);
                              },
                            ),
                        child:
                            controller.selectedPaymentMethod.isEmpty
                                ? _menuTile(
                                  leading: Icon(
                                    Icons.payments,
                                    color: Colors.teal,
                                  ),
                                  iconColor: Colors.teal,
                                  text: "Pilih Pembayaran",
                                )
                                : _menuTile(
                                  leading: Container(
                                    width: 60,
                                    child: SvgPicture.network(
                                      controller
                                          .selectedPaymentMethod['image_url'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  iconColor: Colors.teal,
                                  text:
                                      controller.ovoNumber.value.length <= 0
                                          ? controller
                                              .selectedPaymentMethod['name']
                                          : "+62 ${controller.ovoNumber.value}",
                                ),
                      ),
                    ),
                    const Text(
                      "Kode promo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(() {
                      return controller.diskon.value > 0
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap:
                                    () => showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      builder:
                                          (_) => SafeArea(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: SingleChildScrollView(
                                                child: _kodePromo(context),
                                              ),
                                            ),
                                          ),
                                    ),
                                child: _voucherTile(
                                  leading: Icon(
                                    Icons.redeem,
                                    color: Colors.orange,
                                  ),
                                  iconColor: Colors.orange,
                                  text: controller.promoCode.value,
                                ),
                              ),
                              Row(
                                spacing: 4,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.teal),
                                  Text(
                                    "Kode promo berhasil digunakan",
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                          : InkWell(
                            onTap:
                                () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true, // 🚀 penting
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return SafeArea(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom:
                                              MediaQuery.of(
                                                context,
                                              ).viewInsets.bottom,
                                        ),
                                        child: SingleChildScrollView(
                                          child: _kodePromo(context),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                            child: _voucherTile(
                              leading: Icon(Icons.redeem, color: Colors.orange),
                              iconColor: Colors.orange,
                              text: "Gunakan Kode Promo",
                            ),
                          );
                    }),

                    const Text(
                      "Rincian Pesanan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text("Harga"),
                          Spacer(),
                          Text(
                            controller
                                .formatCurrency(
                                  controller.harga.value.toString(),
                                )
                                .toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    Obx(() {
                      return controller.biayaAdmin.value > 0.0
                          ? Row(
                            children: [
                              Text("Biaya Admin"),
                              Spacer(),
                              Text(
                                controller.formatCurrency(
                                  controller.biayaAdmin.value.toString(),
                                ),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                          : SizedBox();
                    }),
                    Obx(() {
                      return controller.diskon.value > 0.0
                          ? Row(
                            children: [
                              Text(
                                "Diskon",
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "-${controller.formatCurrency(controller.diskon.value.toString())}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          )
                          : SizedBox();
                    }),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            "Total Harga",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            controller.formatCurrency(
                              controller.totalHarga.value.toString(),
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.teal.shade300,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: Colors.teal.shade300,
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            controller.createPayment();
                          },
                          child:
                              controller.loading['bayar'] == false
                                  ? Text("Bayar Sekarang")
                                  : Center(
                                    child: CircularProgressIndicator(
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
          ),
        ),
      ),
    );
  }

  /// --- Tile umum untuk menu ---
  static Widget _menuTile({
    required Widget leading, // bisa Icon, Image, atau SvgPicture
    required String text,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromARGB(255, 215, 215, 215),
          width: 1.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              leading, // 👈 langsung pakai widget
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color.fromARGB(255, 42, 42, 42),
          ),
        ],
      ),
    );
  }

  Widget _voucherTile({
    required Widget leading, // bisa Icon, Image, atau SvgPicture
    required String text,
    Color? iconColor,
  }) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(255, 215, 215, 215),
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                leading, // 👈 langsung pakai widget
                const SizedBox(width: 16),
                Text(text),
              ],
            ),
            controller.promoCode.isEmpty
                ? Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 42, 42, 42),
                )
                : InkWell(
                  onTap: () {
                    controller.voucherController.text = "";
                    controller.removeCode();
                  },
                  child: Icon(
                    Icons.close,
                    color: Color.fromARGB(255, 42, 42, 42),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  /// --- Bottomsheet metode pembayaran ---
  Widget _metodePembayaran(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SizedBox(
        height: screenHeight * 0.5,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Metode Pembayaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Virtual Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200, // tinggi fix biar nggak overflow
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.virtualAccount.length,
                        itemBuilder: (context, index) {
                          final data = controller.virtualAccount[index];
                          final ppnPercent =
                              double.tryParse(
                                controller.box.read("ppn") ?? '0',
                              ) ??
                              0;

                          final adminAmount =
                              double.tryParse(data['biaya_admin']) ?? 0;
                          final adminWithPPN =
                              adminAmount + (adminAmount * (ppnPercent / 100));

                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _methodCard(
                              SvgPicture.network(data['image_url']),
                              name: data['name'],
                              title: data['name'],
                              subtitle: "Biaya Admin",
                              admin: adminWithPPN.toString(),
                              value: data,
                              context: context,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 E-Wallet
                    Text(
                      "E-Wallet",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200, // tinggi fix biar nggak overflow
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.EWallet.length,
                        itemBuilder: (context, index) {
                          final data = controller.EWallet[index];
                          final ppnPercent =
                              double.tryParse(
                                controller.box.read("ppn") ?? '0',
                              ) ??
                              0;
                          final clean =
                              data['biaya_admin'].replaceAll("%", "").trim();
                          final persen = double.tryParse(clean) ?? 0;
                          final adminAmount =
                              controller.totalHarga.value.toDouble() *
                              (persen / 100);
                          final adminWithPPN =
                              adminAmount + (adminAmount * (ppnPercent / 100));
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IntrinsicHeight(
                              child: _methodCard(
                                SvgPicture.network(data['image_url']),
                                name: data['name'],
                                title: data['name'],
                                value: data,
                                subtitle: "Biaya Admin",
                                admin: adminWithPPN.toString(),
                                context: context,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 QR Payments
                    Text(
                      "QR Payments",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200, // tinggi fix biar nggak overflow
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.QR.length,
                        itemBuilder: (context, index) {
                          final data = controller.QR[index];

                          final ppnPercent =
                              double.tryParse(
                                controller.box.read("ppn") ?? '0',
                              ) ??
                              0;
                          final clean =
                              data['biaya_admin'].replaceAll("%", "").trim();
                          final persen = double.tryParse(clean) ?? 0;
                          final adminAmount =
                              controller.totalHarga.value.toDouble() *
                              (persen / 100);
                          final adminWithPPN =
                              adminAmount + (adminAmount * (ppnPercent / 100));
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _methodCard(
                              SvgPicture.network(
                                data['image_url'],
                                fit: BoxFit.contain,
                                placeholderBuilder:
                                    (context) => SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                              ),
                              name: data['name'],
                              title: data['name'],
                              value: data,
                              subtitle: "Biaya Admin",
                              admin: adminWithPPN.toString(),
                              context: context,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _methodCard(
    Widget image, {
    String? title,
    required String name,
    String? subtitle,
    String? admin,
    required Map<String, dynamic> value,
    required BuildContext context,
  }) {
    return SizedBox(
      width: 150,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: const Color.fromARGB(50, 0, 0, 0), width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            controller.ovoNumber.value = "";
            controller.selectedPaymentMethod.value = value;
            controller.countAdmin();
            Navigator.pop(context);
            controller.initHarga();
            controller.selectedPaymentType.value =
                controller
                    .getPaymentCategoryByCode(
                      controller.paymentMethods,
                      controller.selectedPaymentMethod['code'],
                    )
                    .toString();
            // Jika OVO dipilih, munculkan modal input nomor
            if (controller.selectedPaymentMethod['code'] == "OVO") {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                isScrollControlled: true, // supaya bisa full screen jika perlu
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => SafeArea(child: _nomorOvo(context)),
              ).whenComplete(() {
                if (controller.ovoNumber.value.length <= 0) {
                  controller.biayaAdmin.value = 0;
                  controller.selectedPaymentMethod.assignAll({});
                  controller.initHarga();
                }
              });
              ;
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 60, height: 60, child: image),
                const SizedBox(height: 12),
                Text(
                  title ?? name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // biar nggak overflow
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle ?? "Biaya Admin",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                Text(
                  formatRupiah(admin) ?? "Rp. 0",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// --- Bottomsheet kode promo ---
  Widget _kodePromo(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return controller.paymentMethods.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
              child: SingleChildScrollView(
                padding: AppStyle.contentPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kode Promo",
                          style: TextStyle(
                            fontSize: 18,
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

                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.voucherController,
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
                              String text = controller.voucherController.text;

                              if (text.isEmpty) {
                                Get.snackbar(
                                  "Gagal",
                                  "Kode Promo tidak boleh kosong",
                                  backgroundColor: Colors.pink,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              controller.applyCode(
                                controller.voucherController.text,
                              );
                              Navigator.pop(context);
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
  }

  Widget _nomorOvo(BuildContext context) {
    return SafeArea(
      child: Padding(
        // Tambahkan padding di sini
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Obx(() {
          return controller.paymentMethods.isEmpty
              ? Center(child: CircularProgressIndicator())
              : SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
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
                              controller.ovoNumController.text = '';
                              Navigator.pop(context);
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
                                controller: controller.ovoNumController,
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
                                String text = controller.ovoNumController.text;

                                if (text.isEmpty) {
                                  Get.snackbar(
                                    "Gagal",
                                    "Nomor telepon tidak boleh kosong",
                                    backgroundColor: Colors.pink,
                                    colorText: Colors.white,
                                  );
                                } else if (text.length < 10) {
                                  Get.snackbar(
                                    "Gagal",
                                    "Nomor telepon minimal 10 karakter",
                                    backgroundColor: Colors.pink,
                                    colorText: Colors.white,
                                  );
                                } else {
                                  controller.ovoNumber.value =
                                      controller.ovoNumController.text;
                                  Navigator.pop(context);
                                }
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
  }
}
