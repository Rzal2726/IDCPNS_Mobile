import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/payment_checkout_controller.dart';

class PaymentCheckoutView extends GetView<PaymentCheckoutController> {
  const PaymentCheckoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Detail Pembayaran", style: AppStyle.appBarTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        final details = controller.paymentDetails;
        return SingleChildScrollView(
          child: Column(
            children: [
              /// 1. Countdown Card
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Bayar Sebelum",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        // TODO: ganti dengan countdown dari data server
                        buildCountdown(86400),
                      ],
                    ),
                  ),
                ),
              ),

              /// 2. Payment Details Card
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TODO: Ganti SvgPicture.network dengan URL dari server
                        details.isEmpty
                            ? CircularProgressIndicator()
                            : SvgPicture.network(
                              details['payment_details'][0]['method']['image_url'],
                              width: 140,
                            ),

                        SizedBox(height: 16),

                        /// Nama Bank
                        details.isEmpty
                            ? Skeletonizer(
                              enabled: true,
                              child: Text("Nama Bank"),
                            )
                            : Text(
                              details['payment_details'][0]['method']['name'],
                              style: TextStyle(fontSize: 16),
                            ),

                        /// Kode / QR
                        details.isEmpty
                            ? Skeletonizer(
                              enabled: true,
                              child: Text("Kode Bayar"),
                            )
                            : (details['payment_details'][0]['xendit_payment_method_id'] ==
                                    16
                                ? Container(
                                  // TODO: tampilkan QR code dari payment['payment_code']
                                  child: Text("QR Code Placeholder"),
                                )
                                : Text(
                                  details['payment_details'][0]['payment_code'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.tealAccent,
                                  ),
                                )),

                        SizedBox(height: 16),

                        /// Nama Akun
                        Text("Nama Akun", style: TextStyle(fontSize: 16)),
                        details.isEmpty
                            ? Skeletonizer(
                              enabled: true,
                              child: Text("Nama Akun"),
                            )
                            : Text(
                              details['user_name'],
                              style: TextStyle(fontSize: 20),
                            ),

                        SizedBox(height: 16),

                        /// Total Harga
                        Text("Total Harga", style: TextStyle(fontSize: 16)),
                        details.isEmpty
                            ? Skeletonizer(
                              enabled: true,
                              child: Text("Total Harga"),
                            )
                            : Text(
                              formatRupiah(details['amount']),
                              style: TextStyle(fontSize: 20),
                            ),
                      ],
                    ),
                  ),
                ),
              ),

              /// 3. Button to Check Payment Status
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.teal.shade300, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    showPaymentStatusBottomSheet(context, controller);
                  },
                  child: Center(child: Text("Cek Status Pembayaran")),
                ),
              ),

              /// 4. Simulate Payment Button (untuk developer)
              controller.isDeveloper.value
                  ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
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
                        controller.simulatePayment();
                      },
                      child: Center(child: Text("Simulate Payment")),
                    ),
                  )
                  : SizedBox(),

              /// 5. Payment Instructions Card
              Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            controller.option.map((option) {
                              final isSelected =
                                  controller.selectedOption.value == option;
                              return GestureDetector(
                                onTap:
                                    () =>
                                        controller.selectedOption.value =
                                            option,
                                child: Column(
                                  children: [
                                    Text(
                                      option,
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.teal
                                                : Colors.grey[700],
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      height: 2,
                                      width: isSelected ? 20 : 0,
                                      color: Colors.teal,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),

                      SizedBox(height: 16),

                      Container(
                        child: Text("Instruksi Pembayaran Placeholder"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

Widget buildCountdown(int seconds) {
  return TweenAnimationBuilder<Duration>(
    duration: Duration(seconds: seconds),
    tween: Tween(begin: Duration(seconds: seconds), end: Duration.zero),
    onEnd: () {
      debugPrint("Countdown selesai!");
    },
    builder: (context, value, child) {
      String minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
      String secs = value.inSeconds.remainder(60).toString().padLeft(2, '0');
      return Text(
        "$minutes:$secs",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    },
  );
}

void showPaymentStatusBottomSheet(
  BuildContext context,
  PaymentCheckoutController controller,
) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      side: BorderSide(color: Colors.transparent, width: 2),
    ),
    context: context,
    builder: (ctx) {
      return SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cek Status Pembayaran",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // No Invoice
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "No Invoice:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child:
                            controller.paymentDetails.isEmpty
                                ? Skeletonizer(
                                  enabled: true,
                                  child: Container(child: Text("")),
                                )
                                : Text(
                                  controller.paymentDetails['no_order'],
                                  textAlign: TextAlign.end,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Nama Produk
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama Produk:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child:
                            controller.paymentDetails.isEmpty
                                ? Skeletonizer(
                                  enabled: true,
                                  child: Container(child: Text("...")),
                                )
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children:
                                      controller
                                          .paymentDetails['payment_details']
                                          .map<Widget>(
                                            (item) => Text(item['item_name']),
                                          )
                                          .toList(),
                                ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Total Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Harga:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child:
                            controller.paymentDetails.isEmpty
                                ? Skeletonizer(
                                  enabled: true,
                                  child: Container(child: Text("")),
                                )
                                : Text(
                                  formatRupiah(
                                    controller.paymentDetails['amount'],
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child:
                            controller.paymentDetails.isEmpty
                                ? Skeletonizer(
                                  enabled: true,
                                  child: Container(child: Text("")),
                                )
                                : Text(
                                  controller.paymentDetails['status'],
                                  textAlign: TextAlign.end,
                                ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Button Tutup
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.teal.shade300,
                            width: 1.5,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 32,
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: Text("Tutup"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
