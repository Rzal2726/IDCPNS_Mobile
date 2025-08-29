import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/payment_checkout_controller.dart';

class PaymentCheckoutView extends GetView<PaymentCheckoutController> {
  const PaymentCheckoutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Pembayaran"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Countdown
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Text(
                      "Bayar Sebelum",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    buildCountdown(300),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Info Bank + VA
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/bri.png", height: 40), // logo dummy
                    SizedBox(height: 8),
                    Text(
                      controller.bank.value,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text("BRI Virtual Account Number"),
                    SelectableText(
                      controller.vaNumber.value,
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("Nama Akun"),
                    Text(
                      controller.namaAkun.value,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    Text("Total Harga"),
                    Text(
                      "Rp.${controller.totalHarga.value.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Tombol cek status
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: controller.cekStatus,
                child: Text("Cek Status Pembayaran"),
              ),
              SizedBox(height: 16),

              // Tab ATM | MBANKING
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.selectedTab.value = "ATM",
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        controller.selectedTab.value == "ATM"
                                            ? Colors.teal
                                            : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "ATM",
                                  style: TextStyle(
                                    fontWeight:
                                        controller.selectedTab.value == "ATM"
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    color:
                                        controller.selectedTab.value == "ATM"
                                            ? Colors.teal
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap:
                                () => controller.selectedTab.value = "MBANKING",
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        controller.selectedTab.value ==
                                                "MBANKING"
                                            ? Colors.teal
                                            : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "MBANKING",
                                  style: TextStyle(
                                    fontWeight:
                                        controller.selectedTab.value ==
                                                "MBANKING"
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    color:
                                        controller.selectedTab.value ==
                                                "MBANKING"
                                            ? Colors.teal
                                            : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Instruksi
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.instruksiAktif.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${index + 1}. "),
                              Expanded(
                                child: Text(controller.instruksiAktif[index]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
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
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      );
    },
  );
}
