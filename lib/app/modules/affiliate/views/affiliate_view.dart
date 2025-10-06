import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/affiliate_controller.dart';

class AffiliateView extends GetView<AffiliateController> {
  const AffiliateView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // false supaya tidak auto-pop
      onPopInvoked: (didPop) {
        if (!didPop) {
          // Saat tombol back ditekan
          Get.offNamed(Routes.HOME, arguments: {'initialIndex': 4});
          (Get.find<HomeController>()).currentIndex.value = 4;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "Afiliasi",
          onBack: () {
            Get.offNamed(Routes.HOME, arguments: {'initialIndex': 4});
            (Get.find<HomeController>()).currentIndex.value = 4;
          },
        ),
        body: SafeArea(
          child: Obx(() {
            return SingleChildScrollView(
              padding: AppStyle.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKomisiCard(
                    "Total Komisi",
                    controller.komisiTotal.value,
                  ),
                  SizedBox(height: 12),
                  _buildKomisiCard(
                    "Komisi Tersedia",
                    controller.komisiTersedia.value,
                  ),
                  SizedBox(height: 12),
                  _buildKomisiCard(
                    "Komisi Ditarik",
                    controller.komisiDitarik.value,
                  ),
                  SizedBox(height: 24),
                  Text("Informasi", style: AppStyle.styleW900),
                  SizedBox(height: 8),
                  _buildInfoItem(
                    "Kamu berhak mendapatkan komisi atas setiap pembelian paket yang menggunakan kode referral kamu.",
                  ),
                  SizedBox(height: 8),
                  _buildInfoItem(
                    "Kamu dapat mengubah kode referral supaya lebih mudah diingat dan dibagikan.",
                  ),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, size: 18, color: Colors.teal),
                      SizedBox(width: 8),

                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "Informasi selengkapnya : ",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            children: [
                              TextSpan(
                                text: "Klik disini.",
                                style: TextStyle(color: Colors.blue),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        // Panggil dialog ketika ditekan
                                        showAfiliasiDialog(context);
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text("Kode Afiliasi Saya", style: AppStyle.styleW900),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: controller.kodeController,
                        focusNode: FocusNode(),
                        readOnly: controller.affiliateStatus.value == true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade600,
                              width: 1.8,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Visibility(
                        visible: controller.affiliateStatus.value == false,
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 12,
                          ), // atas & bawah 12
                          child: ElevatedButton(
                            onPressed: controller.simpanKode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              minimumSize: Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Simpan",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Text(
                        "Kamu tidak dapat mengubah kode referral jika sudah ada user lain yang memakai kode referral kamu saat daftar.",
                        style: TextStyle(color: Colors.black87, fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Column(
                    children: [
                      _buildMenuItem(
                        icon: Icons.insert_drive_file,
                        title: "Rincian Komisi",
                        subtitle: "Lihat rincian komisi anda",
                        onTap: () {
                          // Aksi ketika diklik
                          Get.offNamed(Routes.COMMISION_DETAIL);
                        },
                      ),
                      SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.attach_money,
                        title: "Tarik Komisi",
                        subtitle: "Ajukan penarikan komisi",
                        onTap: () {
                          Get.toNamed(Routes.TARIK_KOMISI);
                        },
                      ),
                      SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.account_balance,
                        title: "Rekening",
                        subtitle: "Atur rekening untuk penarikan komisi",
                        onTap: () {
                          Get.toNamed(Routes.REKENING);
                        },
                      ),
                      SizedBox(height: 12),
                      _buildMenuItem(
                        icon: Icons.history,
                        title: "Mutasi Saldo",
                        subtitle: "Lihat riwayat penarikan komisi",
                        onTap: () {
                          Get.toNamed(Routes.MUTASI_SALDO);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildKomisiCard(String title, int value) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 85,
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // tetap rata kiri
        mainAxisAlignment:
            MainAxisAlignment.center, // bikin konten ke tengah vertikal
        children: [
          Row(
            children: [
              Icon(Icons.wallet, color: Colors.white, size: 15),
              SizedBox(width: 5),
              Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: Text(
              formatRupiah(value),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, size: 18, color: Colors.teal),
        SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(fontSize: 15))),
      ],
    );
  }
}

Widget _buildMenuItem({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyle.styleW900),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    ),
  );
}

void showAfiliasiDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Info",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Konten Gambar
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Image.asset(
                "assets/afiliasiProfile.png",
                fit: BoxFit.contain,
              ),
            ),

            // Footer tombol di kanan bawah
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16, bottom: 16),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    side: BorderSide(color: Colors.teal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Tutup"),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
