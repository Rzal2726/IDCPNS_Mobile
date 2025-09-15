import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/payment_upgrade_akun_controller.dart';

class PaymentUpgradeAkunView extends GetView<PaymentUpgradeAkunController> {
  const PaymentUpgradeAkunView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            title: const Text('Rincian Pembayaran'),
            centerTitle: false,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    const Text(
                      "Checkout Upgrade",
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
                                controller.detailDurasi['name'] != null
                                    ? Text(controller.detailDurasi['name'])
                                    : Skeletonizer(
                                      enabled: true,
                                      child: Text("Judul TRyout"),
                                    ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.check_box, color: Colors.teal),
                        Container(
                          width: 240,
                          child: Obx(
                            () =>
                                controller.detailBonus['formasi'] != null
                                    ? Text(controller.detailBonus['formasi'])
                                    : Skeletonizer(
                                      enabled: true,
                                      child: Text("Judul TRyout"),
                                    ),
                          ),
                        ),
                      ],
                    ),

                    const Divider(color: Color.fromARGB(250, 230, 230, 230)),
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
                                  leading: SvgPicture.network(
                                    height: 28,
                                    controller
                                        .selectedPaymentMethod['image_url'],
                                  ),
                                  iconColor: Colors.teal,
                                  text:
                                      controller.ovoNumber.value.length <= 0
                                          ? controller
                                              .selectedPaymentMethod['name']
                                          : "+62 ${controller.ovoNumber.value.toString()}",
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
                                          (_) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SingleChildScrollView(
                                              child: _kodePromo(context),
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
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(
                                              context,
                                            ).viewInsets.bottom,
                                      ),
                                      child: SingleChildScrollView(
                                        child: _kodePromo(context),
                                      ),
                                    );
                                  },
                                ),

                            child: _menuTile(
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
              Text(text),
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

  /// --- Bottomsheet metode pembayaran ---
  Widget _metodePembayaran(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Metode Pembayaran",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 12),

            // 🔹 Virtual Account
            Text(
              "Virtual Account",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180, // tinggi fix biar nggak overflow
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.virtualAccount.length,
                itemBuilder: (context, index) {
                  final data = controller.virtualAccount[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _methodCard(
                      SvgPicture.network(data['image_url']),
                      name: data['name'],
                      title: data['name'],
                      subtitle: "Biaya Admin: Rp ${data['biaya_admin']}",
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180, // tinggi fix biar nggak overflow
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.eWallet.length,
                itemBuilder: (context, index) {
                  final data = controller.eWallet[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _methodCard(
                      SvgPicture.network(data['image_url']),
                      name: data['name'],
                      title: data['name'],
                      value: data,
                      subtitle: "Biaya Admin: ${data['biaya_admin']}",
                      context: context,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 QR Payments
            Text(
              "QR Payments",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 180, // tinggi fix biar nggak overflow
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.QR.length,
                itemBuilder: (context, index) {
                  final data = controller.QR[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _methodCard(
                      SvgPicture.network(data['image_url']),
                      name: data['name'],
                      title: data['name'],
                      value: data,
                      subtitle: "Biaya Admin: ${data['biaya_admin']}",
                      context: context,
                    ),
                  );
                },
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
    double admin = 0,
    required Map<String, dynamic> value,
    required BuildContext context,
  }) {
    return SizedBox(
      width: 150,
      height: 160,
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
            // Simpan metode pembayaran yang dipilih
            controller.selectedPaymentMethod.value = value;

            // Hitung biaya admin
            controller.countAdmin();

            // Tutup bottom sheet/popup sebelumnya
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            // Inisialisasi harga setelah memilih metode
            controller.initHarga();

            // Cari payment type berdasarkan code
            final paymentType = controller.getPaymentCategoryByCode(
              controller.paymentMethods,
              controller.selectedPaymentMethod['code'],
            );

            controller.selectedPaymentType.value =
                paymentType?.toString() ?? "";

            // Jika OVO dipilih, munculkan modal input nomor
            if (controller.selectedPaymentMethod['id'] == 10) {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                isScrollControlled: true, // supaya bisa full screen jika perlu
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => _nomorOvo(context),
              ).whenComplete(() {
                if (controller.ovoNumber.value.length <= 0) {
                  controller.biayaAdmin.value = 0;
                  controller.selectedPaymentMethod.assignAll({});
                  controller.initHarga();
                }
              });
            }
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40, child: image),
                const SizedBox(height: 12),
                Text(
                  title ?? name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // biar nggak overflow
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle ?? "Biaya Admin: Rp 0",
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Voucher",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextField(
                controller: controller.voucherController,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey),
                  labelText: "Masukkan Kode Promo",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.teal, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    if (controller.voucherController.text.length < 1) {
                      Get.snackbar(
                        "Gagal",
                        "Mohon isi kode terlebih dahulu",
                        backgroundColor: Colors.pink,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    controller.applyCode(controller.voucherController.text);
                    Navigator.pop(context);
                  },
                  child: const Text("Klaim"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nomorOvo(BuildContext context) {
    return SafeArea(
      child: Padding(
        // Ini yang bikin container naik mengikuti keyboard
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Nomor OVO",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextField(
                  maxLength: 16,
                  controller: controller.ovoNumController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey),
                    labelText: "Masukkan Nomor OVO",
                    prefixText: '+62 ',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.teal, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      if (controller.ovoNumController.text.length <= 0) {
                        Get.snackbar(
                          "Gagal",
                          "Mohon isi nomor ovo anda",
                          backgroundColor: Colors.pink,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      controller.ovoNumber.value =
                          controller.ovoNumController.text;
                      Navigator.pop(context);
                    },
                    child: const Text("Konfirmasi"),
                  ),
                ),
              ],
            ),
          ),
        ),
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
                : IconButton(
                  onPressed: () {
                    controller.voucherController.text = "";
                    controller.removeCode();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Color.fromARGB(255, 42, 42, 42),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
