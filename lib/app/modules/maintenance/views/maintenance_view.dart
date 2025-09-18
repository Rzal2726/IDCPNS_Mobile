import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:url_launcher/link.dart';

import '../controllers/maintenance_controller.dart';

class MaintenanceView extends GetView<MaintenanceController> {
  const MaintenanceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/icon/iconApp.png", width: 120)),
            Text(
              "Halaman Dalam Perbaikan",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
            Text(
              "Mohon maaf kami sedang melakukan perawatan untuk layanan aplikasi yang lebih baik lagi. Silahkan kembali beberapa saat lagi.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              "Untuk informasi lebih lanjut silahkan ikuti sosial media kami",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Facebook
                Link(
                  uri: Uri.parse('https://www.facebook.com/share/1Ga7VCtotP/'),
                  builder: (
                    BuildContext context,
                    Future<void> Function()? followLink,
                  ) {
                    return IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: followLink,
                      icon: const Icon(
                        Icons.facebook,
                        size: 32,
                        color: Colors.black,
                      ),
                    );
                  },
                ),

                // TikTok
                Link(
                  uri: Uri.parse('https://www.tiktok.com'),
                  builder: (
                    BuildContext context,
                    Future<void> Function()? followLink,
                  ) {
                    return IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: followLink,
                      icon: const Icon(
                        Icons.tiktok,
                        size: 32,
                        color: Colors.black,
                      ),
                    );
                  },
                ),

                // Instagram
                Link(
                  uri: Uri.parse(
                    'https://www.instagram.com/idcpns?igsh=MTc4ejN2amhnNnRnYw==',
                  ),
                  builder: (
                    BuildContext context,
                    Future<void> Function()? followLink,
                  ) {
                    return TextButton(
                      onPressed: followLink,
                      child: SvgPicture.asset(
                        "assets/instagram-brands-solid.svg",
                        width: 32,
                      ),
                    );
                  },
                ),

                // Twitter (X)
                Link(
                  uri: Uri.parse(
                    'https://x.com/idcpns?t=Xp6LPpoUCw-OJDd0eNrp0w&s=09',
                  ),
                  builder: (
                    BuildContext context,
                    Future<void> Function()? followLink,
                  ) {
                    return TextButton(
                      onPressed: followLink,
                      child: SvgPicture.asset(
                        "assets/x-twitter-brands-solid-full.svg",
                        width: 32,
                      ),
                    );
                  },
                ),
              ],
            ),
            Text(
              "-IDCPNS",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
