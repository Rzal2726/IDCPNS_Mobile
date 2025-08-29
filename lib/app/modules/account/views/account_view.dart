import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppStyle.sreenPaddingHome, // padding untuk seluruh isi
            child: Column(
              children: [
                // Profile section
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage("assets/avatar.png"),
                      ),
                      SizedBox(width: 18),
                      // Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "Basic",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Upgrade Akun",
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            "radit",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                  3,
                                ), // Sesuaikan padding sesuai kebutuhan untuk ukuran lingkaran
                                decoration: const BoxDecoration(
                                  color:
                                      Colors
                                          .teal, // Warna latar belakang lingkaran
                                  shape: BoxShape.circle, // Bentuk lingkaran
                                ),
                                child: const Icon(
                                  Icons.wallet,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 6),
                              Text("0", style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                // Menu List
                buildMenuItem(Icons.person, "Akun", Routes.MY_ACCOUNT),
                buildMenuItem(Icons.lock, "Kata Sandi", Routes.CHANGE_PASSWORD),
                buildMenuItem(Icons.favorite, "Wishlist", Routes.WISHLIST),
                buildMenuItem(Icons.list_alt, "Transaksi", Routes.TRANSACTION),
                buildMenuItem(
                  Icons.list_alt,
                  "Program Saya",
                  Routes.PROGRAM_SAYA,
                ),
                buildMenuItem(Icons.group, "Afiliasi", Routes.AFFILIATE),
                buildMenuItem(Icons.phone, "Hubungi Kami", Routes.MY_ACCOUNT),
                buildMenuItem(
                  Icons.help_outlined,
                  "Panduan",
                  Routes.MY_ACCOUNT,
                ),
                SizedBox(height: 30),
                // Keluar
                buildMenuItem(Icons.logout, "Keluar", Routes.LOGIN),

                SizedBox(height: 30),

                // Banner (Upgrade ke Platinum)
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Banner Highlight\n(Placeholder)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, String routeName) {
    return InkWell(
      onTap: () => Get.toNamed(routeName),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: Colors.grey[700]),
                      SizedBox(width: 12),
                      Text(title),
                    ],
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),

            Divider(height: 5),
          ],
        ),
      ),
    );
  }
}
