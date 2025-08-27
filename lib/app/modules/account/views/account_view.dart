import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

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
            padding: const EdgeInsets.all(16.0), // padding untuk seluruh isi
            child: Column(
              children: [
                // Profile section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Avatar
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage("assets/avatar.png"),
                      ),
                      const SizedBox(width: 12),
                      // Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  "Basic",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Upgrade Akun",
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "radit",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: const [
                              Icon(Icons.wallet, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("0"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Menu List
                buildMenuItem(Icons.person, "Akun", Routes.MY_ACCOUNT),
                buildMenuItem(Icons.lock, "Kata Sandi", Routes.CHANGE_PASSWORD),
                buildMenuItem(
                  Icons.favorite_border,
                  "Wishlist",
                  Routes.WISHLIST,
                ),
                buildMenuItem(
                  Icons.receipt_long,
                  "Transaksi",
                  Routes.TRANSACTION,
                ),
                buildMenuItem(Icons.book, "Program Saya", Routes.PROGRAM_SAYA),
                buildMenuItem(Icons.group, "Afiliasi", Routes.AFFILIATE),
                buildMenuItem(Icons.phone, "Hubungi Kami", Routes.MY_ACCOUNT),
                buildMenuItem(Icons.help_outline, "Panduan", Routes.MY_ACCOUNT),

                // Keluar
                buildMenuItem(Icons.logout, "Keluar", Routes.LOGIN),

                const SizedBox(height: 12),

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
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[700]),
        title: Text(title),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          Get.toNamed(routeName);
        },
      ),
    );
  }
}
