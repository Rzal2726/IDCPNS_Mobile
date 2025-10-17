import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';

import '../controllers/pembayaran_berhasil_controller.dart';

class PembayaranBerhasilView extends GetView<PembayaranBerhasilController> {
  const PembayaranBerhasilView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/logo.png', // Dummy logo
          height: 55,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none, color: Colors.teal),
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
      body: Container(
        margin: EdgeInsets.all(48),
        child: Center(
          child: Column(
            spacing: 16,
            children: [
              SvgPicture.asset("assets/success-e00e456b.svg"),
              Text(
                'Mohon menunggu, proses ini membutuhkan waktu 1x24 jam. Apabila setelah 1x24 jam produk tidak muncul, silahkan hubungi admin.',
                style: TextStyle(fontSize: 14),
              ),
              ElevatedButton(
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
                  Get.offAllNamed("/home");
                },
                child: Center(child: Text("Kembali Ke Home")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
