import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';

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
          spacing: 32,
          children: [
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
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
                      Text(
                        "00:00:00",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
              child: Container(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SvgPicture.network(
                          "https://idcpns.com/img/payment-method/bca.svg",
                          width: 140,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "BCA Virtual Account Number",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "112233445566",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.tealAccent,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text("Nama Akun", style: TextStyle(fontSize: 16)),
                      Text("John Doe", style: TextStyle(fontSize: 20)),
                      SizedBox(height: 16),
                      Text("Total Harga", style: TextStyle(fontSize: 16)),
                      Text("Rp.9.000", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),

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
                onPressed: () {},
                child: Center(child: Text("Cek Status Pembayaran")),
              ),
            ),

            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
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
                        if (controller.selectedOption.value == "ATM") {
                          return Center(child: Text("Tutorial ATM"));
                        } else if (controller.selectedOption.value ==
                            "MBanking") {
                          return Center(child: Text("Tutorial MBanking"));
                        } else {
                          return Center(child: Text("Tutorial ATM"));
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
}
