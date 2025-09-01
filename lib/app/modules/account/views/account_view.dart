import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
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
                        Container(
                          padding: EdgeInsets.all(
                            2,
                          ), // jarak antara border dan avatar
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  Colors
                                      .white, // ganti warna yang kontras dengan background
                              width: 2, // tipis tapi terlihat
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.blue, // warna avatar
                            backgroundImage:
                                controller.photoProfile.isNotEmpty &&
                                        controller.photoProfile.isNotEmpty
                                            .toString()
                                            .isNotEmpty
                                    ? NetworkImage(
                                      controller.photoProfile.toString(),
                                    )
                                    : AssetImage("assets/profileDefault.jpeg")
                                        as ImageProvider,
                          ),
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
                              "${controller.nameUser}",
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
                                Text(
                                  "${controller.saldo}",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  // Menu List
                  buildMenuItem(
                    icon: Icons.person,
                    title: "Akun",
                    onTap: () => Get.toNamed(Routes.MY_ACCOUNT),
                  ),
                  buildMenuItem(
                    icon: Icons.lock,
                    title: "Kata Sandi",
                    onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
                  ),
                  buildMenuItem(
                    icon: Icons.favorite,
                    title: "Wishlist",
                    onTap: () => Get.toNamed(Routes.WISHLIST),
                  ),
                  buildMenuItem(
                    icon: Icons.list_alt,
                    title: "Transaksi",
                    onTap: () => Get.toNamed(Routes.TRANSACTION),
                  ),
                  buildMenuItem(
                    icon: Icons.list_alt,
                    title: "Program Saya",
                    onTap: () => Get.toNamed(Routes.PROGRAM_SAYA),
                  ),
                  buildMenuItem(
                    icon: Icons.group,
                    title: "Afiliasi",
                    onTap: () => Get.toNamed(Routes.AFFILIATE),
                  ),
                  Column(
                    children: [
                      buildMenuItem(
                        icon: Icons.phone,
                        title: "Hubungi Kami",
                        onTap: () {
                          controller.launchWhatsApp();
                        },
                      ),

                      buildMenuItem(
                        icon: Icons.help_outlined,
                        title: "Panduan",
                        onTap: () {
                          controller.launchHelp();
                        },
                      ),
                      SizedBox(height: 30),
                      // Keluar
                      buildMenuItem(
                        icon: Icons.logout,
                        title: "Keluar",
                        onTap: () {
                          final box = GetStorage();
                          box.erase();

                          // Pindah ke halaman login tanpa memanggil clear/dispose
                          Get.offAllNamed(Routes.LOGIN);
                        },
                      ),

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
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap, // fleksibel, bisa route atau fungsi lain
  }) {
    final controller = Get.put(AccountController());
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: Colors.black54),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ), // panah kanan
              ],
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey[300]), // divider tipis
      ],
    );
  }
}
