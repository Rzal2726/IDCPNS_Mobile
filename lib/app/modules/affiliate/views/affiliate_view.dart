import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/affiliate_controller.dart';

class AffiliateView extends GetView<AffiliateController> {
  const AffiliateView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Afiliasi', style: AppStyle.appBarTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.notifications_none, color: Colors.teal, size: 28),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '9+',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppStyle.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKomisiCard("Total Komisi", controller.totalKomisi),
              SizedBox(height: 12),
              _buildKomisiCard("Komisi Tersedia", controller.komisiTersedia),
              SizedBox(height: 12),
              _buildKomisiCard("Komisi Ditarik", controller.komisiDitarik),
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
                  Icon(Icons.info_outline, size: 18, color: Colors.black54),
                  SizedBox(width: 8),

                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "Informasi selengkapnya : ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Klik disini.",
                            style: const TextStyle(color: Colors.blue),
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
              TextField(
                controller: controller.kodeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200, // background abu muda
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400, // border normal abu
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          Colors.grey.shade600, // border pas ngetik lebih gelap
                      width: 1.8,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),
              ElevatedButton(
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
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Kamu tidak dapat mengubah kode referral jika sudah ada user lain yang memakai kode referral kamu saat daftar.",
                style: TextStyle(color: Colors.black87, fontSize: 15),
              ),
              SizedBox(height: 32),
              Text("Link Afiliasi Saya", style: AppStyle.styleW900),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.copy, color: Colors.black54, size: 15),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "https://idcpns.com/app/daftar?ref=AWJQLGN",
                        style: TextStyle(color: Colors.black87, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
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
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    icon: Icons.attach_money,
                    title: "Tarik Komisi",
                    subtitle: "Ajukan penarikan komisi",
                    onTap: () {
                      Get.offNamed(Routes.TARIK_KOMISI);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    icon: Icons.account_balance,
                    title: "Rekening",
                    subtitle: "Atur rekening untuk penarikan komisi",
                    onTap: () {
                      Get.offNamed(Routes.REKENING);
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    icon: Icons.history,
                    title: "Mutasi Saldo",
                    subtitle: "Lihat riwayat penarikan komisi",
                    onTap: () {
                      Get.offNamed(Routes.MUTASI_SALDO);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKomisiCard(String title, RxInt value) {
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
          Obx(
            () => Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                value.value.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
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
        Icon(Icons.radio_button_checked, size: 18, color: Colors.black54),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppStyle.styleW900),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
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
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Info",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Konten Gambar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                "assets/afiliasiProfile.png",
                fit: BoxFit.contain,
              ),
            ),

            // Footer tombol di kanan bawah
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 16),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    side: const BorderSide(color: Colors.teal),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Tutup"),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
