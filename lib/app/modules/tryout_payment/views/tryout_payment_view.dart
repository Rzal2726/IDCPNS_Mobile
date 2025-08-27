import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/tryout_payment_controller.dart';

class TryoutPaymentView extends GetView<TryoutPaymentController> {
  TryoutPaymentView({super.key});
  final controller = Get.put(TryoutPaymentController());
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
                  const Row(
                    spacing: 4,
                    children: [
                      Icon(Icons.check_box, color: Colors.green),
                      Text("Paket Tryout SKD"),
                    ],
                  ),
                  const Text(
                    "Tryout Lainnya",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Obx(() {
                    return SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.otherTryout.length,
                        itemBuilder: (context, index) {
                          final data = controller.otherTryout[index];
                          return _otherTryoutCard(
                            data['judul'],
                            controller.formatCurrency(data['harga']),
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
                          controller.selectedPaymentMethod.value == ""
                              ? _menuTile(
                                leading: Icon(Icons.payments),
                                iconColor: Colors.green,
                                text: "Pilih Pembayaran",
                              )
                              : _menuTile(
                                leading: SvgPicture.network(
                                  controller.paymentMethods[controller
                                      .selectedPaymentMethod
                                      .value]!['image'],
                                ),
                                iconColor: Colors.green,
                                text:
                                    controller.selectedPaymentMethod.value
                                        .toUpperCase(),
                              ),
                    ),
                  ),
                  const Text(
                    "Kode promo",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap:
                        () => showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (_) => _kodePromo(),
                        ),
                    child: _menuTile(
                      leading: Icon(Icons.redeem),
                      iconColor: Colors.orange,
                      text: "Gunakan Kode Promo",
                    ),
                  ),
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
                    return controller.biayaAdmin.value > 0
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

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.green.shade300,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.green.shade300,
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {},
                      child: const Text("Bayar Sekarang"),
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
  static Widget _otherTryoutCard(String judul, String harga) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(
          color: Color.fromARGB(250, 230, 230, 230),
          width: 1.5,
        ),
      ),
      elevation: 0,
      color: Colors.white,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                Text(
                  harga,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_box,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: double.infinity),
          Text(
            textAlign: TextAlign.start,
            "Metode Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Text(
            textAlign: TextAlign.start,
            "Virtual Account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Wrap(
            spacing: 0,
            runSpacing: 0,
            children: [
              _methodCard(
                SvgPicture.network(
                  "https://idcpns.com/img/payment-method/bni.svg",
                ),
                name: "BNI",

                title: "Bank BNI",
                subtitle: "Biaya Admin: Rp 1.000",
                admin: 1000,
                context: context,
              ),
              _methodCard(
                SvgPicture.network(
                  "https://idcpns.com/img/payment-method/bca.svg",
                ),
                name: "BCA",

                title: "Bank BCA",
                subtitle: "Biaya Admin: Rp 1.000",
                admin: 1000,
                context: context,
              ),
              _methodCard(
                SvgPicture.network(
                  "https://idcpns.com/img/payment-method/mandiri.svg",
                ),
                name: "MANDIRI",

                title: "Mandiri",
                subtitle: "Biaya Admin: Rp 1.000",
                admin: 1000,
                context: context,
              ),
            ],
          ),
          Text(
            textAlign: TextAlign.start,
            "E-Wallet",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Wrap(
            spacing: 0,
            runSpacing: 0,
            children: [
              _methodCard(
                SvgPicture.network(
                  "https://idcpns.com/img/payment-method/ovo.svg",
                ),
                name: "OVO",

                title: "OVO",
                subtitle: "Biaya Admin: Rp 1.000",
                admin: 1000,
                context: context,
              ),
              _methodCard(
                SvgPicture.network(
                  "https://idcpns.com/img/payment-method/dana.svg",
                ),
                name: "DANA",

                title: "DANA",
                subtitle: "Biaya Admin: Rp 1.000",
                admin: 1000,
                context: context,
              ),
            ],
          ),
          Text(
            textAlign: TextAlign.start,
            "QR Payments",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Wrap(
            spacing: 0,
            runSpacing: 0,
            children: [
              _methodCard(
                SvgPicture.network(
                  "https://idcpns.com/img/payment-method/qris.svg",
                ),
                name: "QRIS",
                title: "QRIS",
                subtitle: "Biaya Admin: Rp 0",
                admin: 0,
                context: context,
              ),
            ],
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
    int admin = 0,
    required BuildContext context,
  }) {
    return SizedBox(
      width: 120, // biar konsisten
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(color: const Color.fromARGB(50, 0, 0, 0), width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            controller.selectedPaymentMethod.value = name;
            controller.biayaAdmin.value = admin;
            print(controller.biayaAdmin.value);
            Navigator.pop(context);
            controller.initHarga();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40, child: image), // logo biar rata
                const SizedBox(height: 12),
                Text(
                  title ?? "Bank BNI",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle ?? "Biaya Admin: Rp 0",
                  textAlign: TextAlign.center,
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
  static Widget _kodePromo() {
    return Padding(
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
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.grey),
              labelText: "Masukkan Kode Promo",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.greenAccent.shade100,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.greenAccent.shade100,
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
                backgroundColor: Colors.green.shade300,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.green.shade300, width: 1.5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {},
              child: const Text("Klaim"),
            ),
          ),
        ],
      ),
    );
  }
}
