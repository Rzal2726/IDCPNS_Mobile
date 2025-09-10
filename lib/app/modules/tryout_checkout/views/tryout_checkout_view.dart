import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/tryout_checkout_controller.dart';

class TryoutCheckoutView extends GetView<TryoutCheckoutController> {
  TryoutCheckoutView({super.key});
  final controller = Get.put(TryoutCheckoutController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Image.asset(
          'assets/logo.png', // Dummy logo
          height: 40,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_rounded, color: Colors.teal),
                onPressed: () {
                  Get.to(NotificationView());
                },
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '4',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Container(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    spacing: 8,
                    children: [
                      Text(
                        "Bayar Sebelum",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      buildCountdown(86400),
                    ],
                  ),
                ),
              ),
            ),

            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Container(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () =>
                            controller.paymentDetails.isEmpty
                                ? Center(child: CircularProgressIndicator())
                                : Center(
                                  child: SvgPicture.network(
                                    controller
                                        .paymentDetails['payment_details'][0]['method']['image_url'],
                                    width: 140,
                                  ),
                                ),
                      ),
                      SizedBox(height: 16),
                      Obx(
                        () =>
                            controller.paymentDetails.isEmpty
                                ? Skeletonizer(
                                  enabled: true,
                                  child: Text("Nama Bank"),
                                )
                                : Text(
                                  controller
                                      .paymentDetails['payment_details'][0]['method']['name'],
                                  style: TextStyle(fontSize: 16),
                                ),
                      ),
                      Obx(
                        () =>
                            controller.paymentDetails.isEmpty
                                ? Skeletonizer(
                                  enabled: true,
                                  child: Text("Nama Bank"),
                                )
                                : controller
                                        .paymentDetails['payment_details'][0]['xendit_payment_method_id'] ==
                                    16
                                ? PrettyQrView.data(
                                  data:
                                      controller
                                          .paymentDetails['payment_details'][0]['payment_code'] ??
                                      "",
                                )
                                : Row(
                                  children: [
                                    SelectableText(
                                      controller
                                              .paymentDetails['payment_details'][0]['payment_code'] ??
                                          "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    controller.paymentDetails['payment_details'][0]['payment_code'] !=
                                            null
                                        ? TextButton.icon(
                                          onPressed: () {
                                            Clipboard.setData(
                                              ClipboardData(
                                                text:
                                                    controller
                                                        .paymentDetails['payment_details'][0]['payment_code'] ??
                                                    "",
                                              ),
                                            );
                                          },
                                          label: Icon(Icons.copy),
                                        )
                                        : SizedBox(),
                                  ],
                                ),
                      ),
                      SizedBox(height: 16),
                      Text("Nama Akun", style: TextStyle(fontSize: 16)),
                      Obx(
                        () =>
                            controller.paymentDetails.isEmpty
                                ? Skeletonizer(
                                  enabled: true,
                                  child: Text("Nama Bank"),
                                )
                                : Text(
                                  controller.paymentDetails['user_name'],
                                  style: TextStyle(fontSize: 20),
                                ),
                      ),
                      SizedBox(height: 16),
                      Text("Total Harga", style: TextStyle(fontSize: 16)),
                      Obx(
                        () =>
                            controller.paymentDetails.isEmpty
                                ? Skeletonizer(
                                  enabled: true,
                                  child: Text("Nama Bank"),
                                )
                                : Text(
                                  controller.formatCurrency(
                                    controller.paymentDetails['amount'],
                                  ),
                                  style: TextStyle(fontSize: 20),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.teal.shade300,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Colors.teal.shade300, // ganti warna border
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16), // Sudut atas melengkung
                      ),
                      side: BorderSide(
                        color: Colors.transparent, // warna border
                        width: 2, // ketebalan border
                      ),
                    ),

                    context: context,
                    builder: (ctx) {
                      return Obx(
                        () => SingleChildScrollView(
                          padding: EdgeInsets.all(16),

                          child: Column(
                            spacing: 16,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cek Status Pembayaran",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "No Invoice:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller.paymentDetails.isEmpty
                                      ? Skeletonizer(
                                        enabled: true,
                                        child: Container(
                                          child: Text(
                                            "Lorem Ipsum Odor, Lorem ipsum dolor, Ini Tutorial ATM",
                                          ),
                                        ),
                                      )
                                      : Container(
                                        child: Text(
                                          controller.paymentDetails['no_order'],
                                          style: TextStyle(),
                                        ),
                                      ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Nama Produk:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  controller.paymentDetails.isEmpty
                                      ? Skeletonizer(
                                        enabled: true,
                                        child: Container(
                                          child: Text(
                                            "Lorem Ipsum Odor, Lorem ipsum dolor, Ini Tutorial ATM",
                                          ),
                                        ),
                                      )
                                      : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children:
                                            controller
                                                .paymentDetails['payment_details']
                                                .map<Widget>(
                                                  (item) => Container(
                                                    width: 240,
                                                    child: Text(
                                                      textAlign: TextAlign.end,
                                                      item['item_name'],
                                                      style: TextStyle(),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Harga:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller.paymentDetails.isEmpty
                                      ? Skeletonizer(
                                        enabled: true,
                                        child: Container(
                                          child: Text(
                                            "Lorem Ipsum Odor, Lorem ipsum dolor, Ini Tutorial ATM",
                                          ),
                                        ),
                                      )
                                      : Container(
                                        child: Text(
                                          controller.formatCurrency(
                                            controller.paymentDetails['amount'],
                                          ),
                                          style: TextStyle(),
                                        ),
                                      ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Status:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  controller.paymentDetails.isEmpty
                                      ? Skeletonizer(
                                        enabled: true,
                                        child: Container(
                                          child: Text(
                                            "Lorem Ipsum Odor, Lorem ipsum dolor, Ini Tutorial ATM",
                                          ),
                                        ),
                                      )
                                      : Text(
                                        controller.paymentDetails['status'],
                                        style: TextStyle(),
                                      ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 32),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.teal.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color:
                                            Colors
                                                .teal
                                                .shade300, // ganti warna border
                                        width: 1.5,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                  },
                                  child: Center(child: Text("Tutup")),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Center(child: Text("Cek Status Pembayaran")),
              ),
            ),
            Obx(
              () =>
                  controller.isDeveloper.value == true
                      ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 32),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.teal.shade300,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color:
                                    Colors.teal.shade300, // ganti warna border
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
            ),
            SizedBox(height: 16),

            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Container(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:
                              controller.option.map((option) {
                                final isSelected =
                                    controller.selectedOption.value == option;
                                return GestureDetector(
                                  onTap:
                                      () =>
                                          controller.selectedOption.value =
                                              option,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
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
                                        SizedBox(height: 4),
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          height: 2,
                                          width: isSelected ? 20 : 0,
                                          color: Colors.teal,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                        );
                      }),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Color.fromARGB(250, 240, 240, 240),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Obx(() {
                        final details = controller.paymentDetails;
                        final instructions =
                            details?['payment_details']?[0]?['instructions']
                                as List? ??
                            [];

                        String getInstruction(int index) {
                          if (instructions.isEmpty)
                            return "<p>Tidak ada instruksi untuk metode pembayaran ini</p>";
                          if (index < 0 || index >= instructions.length)
                            return "<p>No Instruction</p>";
                          return instructions[index]?['instruction'] ??
                              "<p>No Instruction</p>";
                        }

                        if (controller.selectedOption.value == "ATM") {
                          return details.isEmpty
                              ? Skeletonizer(
                                enabled: true,
                                child: Text(
                                  "Lorem Ipsum Odor, Lorem ipsum dolor, Ini Tutorial ATM",
                                ),
                              )
                              : Html(data: getInstruction(1));
                        } else if (controller.selectedOption.value ==
                            "MBanking") {
                          return details.isEmpty
                              ? Skeletonizer(
                                enabled: true,
                                child: Text(
                                  "Lorem Ipsum Odor, Lorem ipsum dolor, Ini Tutorial MBanking",
                                ),
                              )
                              : Html(data: getInstruction(0));
                        } else {
                          return Skeletonizer(
                            enabled: true,
                            child: Text(
                              "Lorem Ipsum Odor, Lorem ipsum dolor, Ini Tutorial ATM",
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCountdown(int seconds) {
    return TweenAnimationBuilder<Duration>(
      duration: Duration(seconds: seconds),
      tween: Tween(begin: Duration(seconds: seconds), end: Duration.zero),
      onEnd: () {
        debugPrint("Countdown selesai!");
      },
      builder: (context, value, child) {
        // Ambil jam, menit, detik
        String hours = value.inHours.toString().padLeft(2, '0');
        String minutes = value.inMinutes
            .remainder(60)
            .toString()
            .padLeft(2, '0');
        String secs = value.inSeconds.remainder(60).toString().padLeft(2, '0');

        return Text(
          "$hours:$minutes:$secs",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
