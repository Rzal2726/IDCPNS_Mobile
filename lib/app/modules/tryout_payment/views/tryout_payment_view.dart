import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/tryout_payment_controller.dart';

class TryoutPaymentView extends GetView<TryoutPaymentController> {
  TryoutPaymentView({super.key});
  final controller = Get.put(TryoutPaymentController());
  final voucherController = TextEditingController();
  final ovoNumController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Rincian Pembayaran'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
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
                    "Checkout Paket Tryout",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Icon(Icons.check_box, color: Colors.teal),
                      Container(
                        width: 240,
                        child: Obx(
                          () =>
                              controller.dataTryout['formasi'] != null
                                  ? Text(controller.dataTryout['formasi'])
                                  : Skeletonizer(
                                    enabled: true,
                                    child: Text("Judul TRyout"),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Tryout Lainnya",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Obx(() {
                    Map<String, dynamic> nul = {};
                    return controller.otherTryout.isEmpty
                        ? Skeletonizer(
                          enabled: true,
                          child: _otherTryoutCard(
                            "Judul Tryout",
                            "0000000",
                            value: nul,
                          ),
                        )
                        : SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.otherTryout.length,
                            itemBuilder: (context, index) {
                              final data = controller.otherTryout[index];
                              return _otherTryoutCard(
                                data['formasi'] ?? "-",
                                controller.formatCurrency(
                                  data['final_price']?.toString() ?? "0",
                                ),
                                value: data,
                              );
                            },
                          ),
                        );
                  }),

                  const Divider(color: Color.fromARGB(250, 230, 230, 230)),
                  const Text(
                    "Metode Pembayaran",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                  controller.selectedPaymentMethod['image_url'],
                                ),
                                iconColor: Colors.teal,
                                text: controller.selectedPaymentMethod['name'],
                              ),
                    ),
                  ),
                  const Text(
                    "Kode promo",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              child: _menuTile(
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Text("Harga"),
                        Spacer(),
                        Text(
                          controller
                              .formatCurrency(controller.harga.value.toString())
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
    );
  }

  /// --- Card Tryout lainnya ---
  Widget _otherTryoutCard(
    String judul,
    String harga, {
    required Map<String, dynamic> value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color.fromARGB(250, 230, 230, 230),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      width: 160,
      padding: const EdgeInsets.only(left: 8, top: 8),
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            judul,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,

            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(harga, style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                tooltip:
                    value['is_purchase'] == true
                        ? "Hapus dari keranjang"
                        : "Tambah ke keranjang",
                onPressed: () {
                  final idx = controller.otherTryout.indexOf(value);

                  if (value['is_purchase'] == false) {
                    value['is_purchase'] = true;
                    controller.addTryout(value);
                  } else {
                    controller.removeTryout(value);
                    value['is_purchase'] = false;
                  }

                  controller.otherTryout[idx] = Map<String, dynamic>.from(
                    value,
                  ); // 🔥 ini penting supaya Obx rebuild
                },
                icon: Icon(
                  value['is_purchase'] != true
                      ? Icons.add_box
                      : Icons.disabled_by_default,
                  color:
                      value['is_purchase'] != true ? Colors.teal : Colors.pink,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
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
    return SingleChildScrollView(
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
              itemCount: controller.EWallet.length,
              itemBuilder: (context, index) {
                final data = controller.EWallet[index];
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
                builder: (context) => _nomorOvo(context),
              );
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
            controller: voucherController,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.grey),
              labelText: "Masukkan Kode Promo",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.tealAccent.shade100,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.tealAccent.shade100,
                  width: 2.0,
                ),
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
                controller.applyCode(voucherController.text);
                Navigator.pop(context);
              },
              child: const Text("Klaim"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nomorOvo(BuildContext context) {
    return Padding(
      // Ini yang bikin container naik mengikuti keyboard
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
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
                controller: ovoNumController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.grey),
                  labelText: "Masukkan Nomor OVO",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.tealAccent.shade100,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.tealAccent.shade100,
                      width: 2.0,
                    ),
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
                    controller.ovoNumber.value = ovoNumController.text;
                    Navigator.pop(context);
                  },
                  child: const Text("Konfirmasi"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
