import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            padding: AppStyle.sreenPaddingHome,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Highlight Section
                Text(
                  'Highlight',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 150,
                    autoPlay: true,
                    autoPlayInterval: Duration(
                      seconds: 5,
                    ), // ganti slide tiap 3 detik
                    autoPlayAnimationDuration: Duration(milliseconds: 1000),
                    enlargeCenterPage: true,
                    viewportFraction: 1, // biar full lebar container
                  ),
                  items: [
                    for (var banner in controller.bannerData)
                      GestureDetector(
                        onTap: () async {
                          final url = banner['link'];
                          final uri = Uri.parse(url); // ubah string jadi Uri

                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            print("Could not launch $url");
                          }
                        },
                        child: Container(
                          height: 150,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/afiliasiBanner.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 50),
                controller.bimbelRemainder.isNotEmpty
                    ? Column(
                      children: [
                        for (var data in controller.bimbelRemainder)
                          Container(
                            padding: AppStyle.screenPadding,
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Pengingat Bimbel",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['bimbel_parent_name'] ?? '-',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      // Judul
                                      Text(
                                        data['judul'] ?? '-',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      // Hari, Tanggal, Jam
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "Hari",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                data['jadwal_tanggal']['hari'] ??
                                                    '-',
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Tanggal",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                data['jadwal_tanggal']['tanggal'] ??
                                                    '-',
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                "Jam",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                data['jadwal_tanggal']['jam'] ??
                                                    '-',
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      // Tombol Pretest + Buka Kelas
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                Get.toNamed(
                                                  Routes.PRETEST_DETAIL,
                                                );
                                              },
                                              icon: Icon(
                                                Icons.assignment,
                                                size: 18,
                                              ),
                                              label: Text('Pretest'),
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor: Colors.amber,
                                                foregroundColor: Colors.white,
                                                side: BorderSide(
                                                  color: Colors.amber,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                minimumSize: Size(0, 40),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                // aksi buka kelas
                                              },
                                              icon: Icon(
                                                Icons.computer,
                                                size: 18,
                                              ),
                                              label: Text('Buka Kelas'),
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor: Colors.teal,
                                                foregroundColor: Colors.white,
                                                side: BorderSide(
                                                  color: Colors.teal,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                minimumSize: Size(0, 40),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )
                    : SizedBox.shrink(),

                // Pilih Layanan
                Text(
                  'Pilih Layanan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Pilih layanan yang cocok sebagai teman belajar kamu'),
                SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.TRYOUT); // ganti dengan route kamu
                        },
                        child: _buildServiceCard(
                          'assets/tryoutHomeIcon.svg',
                          'Tryout',
                          Colors.teal,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),

                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.BIMBEL);
                        },
                        child: _buildServiceCard(
                          'assets/bimbelHomeIcon.svg',
                          'Bimbel',
                          Colors.teal,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: _buildServiceCard(
                        'assets/platinumHomeIcon.svg',
                        'Platinum',
                        Colors.orange,
                        badge: 'Baru',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50),

                // Pilih Kategori
                Text(
                  'Pilih Kategori',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  style: TextStyle(color: Colors.grey),
                  'Pilih kategori yang cocok sebagai teman belajar kamu',
                ),
                SizedBox(height: 30),

                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      for (int i = 0; i < controller.kategoriData.length; i++)
                        _buildCategoryItem(
                          controller.kategoriData[i]['menu'],
                          controller.kategoriData[i]['logo'],
                          controller.kategoriData[i]['id'].toString(),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 50),

                Text(
                  'Rekomendasi Penunjang Program ${controller.recomenData['menu']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  style: TextStyle(color: Colors.grey),
                  'Pilihan utama kami untuk anda',
                ),
                SizedBox(height: 30),
                controller.recomenData['tryout_formasi'] != null
                    ? Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.DETAIL_MY_BIMBEL);
                          },
                          child: Container(
                            padding: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[300]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    height: 180,
                                    width: 240,
                                    child: Image.network(
                                      '${controller.recomenData['tryout_formasi']['gambar']}',
                                    ),
                                  ),
                                ),

                                // Area gambar dengan background dan icon dummy
                                SizedBox(height: 16),
                                // Judul "Platinum"
                                Text(
                                  '${controller.recomenData['tryout_formasi']['formasi']}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),

                                // Deskripsi
                                Text(
                                  'Siap bersaing bersama ribuan peserta seleksi Rekrutmen Bersama ${controller.recomenData['menu']} lainnya! Ayo persiapkan diri kamu untuk seleksi ${controller.recomenData['menu']} selanjutnya dari sekarang dengan mengikuti ${controller.recomenData['tryout_formasi']['formasi']} dari ${controller.recomenData['menu']} ini.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Harga coret
                                Text(
                                  formatRupiah(
                                    controller
                                        .recomenData['tryout_formasi']['harga'],
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                // Harga utama
                                Text(
                                  formatRupiah(
                                    controller
                                        .recomenData['tryout_formasi']['harga_fix'],
                                  ),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10),
                      ],
                    )
                    : SizedBox.shrink(),

                controller.recomenData['bimbel_parent'] != null
                    ? Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  height: 180,
                                  width: 240,
                                  child: Image.network(
                                    '${controller.recomenData['bimbel_parent']['gambar']}',
                                  ),
                                ),
                              ),

                              // Area gambar dengan background dan icon dummy
                              SizedBox(height: 16),
                              // Judul "Platinum"
                              Text(
                                '${controller.recomenData['bimbel_parent']['formasi']}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),

                              // Deskripsi
                              Text(
                                'Siap bersaing bersama ribuan peserta seleksi Rekrutmen Bersama ${controller.recomenData['menu']} lainnya! Ayo persiapkan diri kamu untuk seleksi ${controller.recomenData['menu']} selanjutnya dari sekarang dengan mengikuti ${controller.recomenData['bimbel_parent']['formasi']} dari ${controller.recomenData['menu']} ini.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 16),

                              // Harga coret
                              Text(
                                formatRupiah(
                                  controller
                                      .recomenData['bimbel_parent']['harga'],
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              // Harga utama
                              Text(
                                formatRupiah(
                                  controller
                                      .recomenData['bimbel_parent']['harga_fix'],
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    )
                    : SizedBox.shrink(),
                controller.recomenData['upgrade'] != null
                    ? Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  height: 180,
                                  width: 240,
                                  child:
                                      controller.recomenData['upgrade']['gambar'] ==
                                              null
                                          ? Image.asset('assets/squareLogo.png')
                                          : Image.network(
                                            '${controller.recomenData['upgrade']['gambar']}',
                                          ),
                                ),
                              ),

                              // Area gambar dengan background dan icon dummy
                              SizedBox(height: 16),
                              // Judul "Platinum"
                              Text(
                                '${controller.recomenData['upgrade']['name']}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.brown,
                                ),
                              ),
                              SizedBox(height: 8),

                              // Deskripsi
                              Text(
                                'Upgrade jenis akun Anda menjadi Platinum dan dapatkan berbagai macam fitur unggulan seperti Video Series, E-book, Tryout Harian, dan Webinar yang dapat meningkatkan persiapan kamu lebih optimal lagi.',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 16),

                              // Harga coret
                              Text(
                                "${formatRupiah(controller.recomenData['upgrade']['price_list']['harga_terendah'])} - ${formatRupiah(controller.recomenData['upgrade']['price_list']['harga_tertinggi'])}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              // Harga utama
                              Text(
                                "${formatRupiah(controller.recomenData['upgrade']['price_list']['harga_fix_terendah'])} - ${formatRupiah(controller.recomenData['upgrade']['price_list']['harga_fix_tertinggi'])}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    )
                    : SizedBox.shrink(),

                SizedBox(height: 50),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul dan deskripsi
                      Text(
                        'Event Tryout Gratis',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        style: TextStyle(color: Colors.grey),
                        'Ikuti event tryout dari rekomendasi kita untuk anda!',
                      ),
                      SizedBox(height: 30),

                      // Search field
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal, width: 1.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 15.0,
                            ), // Sesuaikan nilai vertical
                            hintText: 'Cari',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.search, color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      // Tombol Filter
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Colors.teal, // Mengatur warna teks dan ikon
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize
                                    .min, // Agar Row tidak mengambil lebar penuh
                            children: [
                              Text('Filter', style: TextStyle(fontSize: 16)),
                              SizedBox(
                                width: 4,
                              ), // Memberikan jarak antara teks dan ikon
                              Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      // Tampilan kosong (empty state)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/emptyArchiveIcon.svg"),
                            SizedBox(height: 16),
                            Text(
                              'Belum Ada Event Berlangsung',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 50), // Jarak bawah yang lebih jauh
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  'Rekomendasi Tryout',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                //
                Text(
                  'Ikuti event tryout dari rekomendasi kita untuk anda!',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 30),

                SvgPicture.asset("assets/learningEmpty.svg"),

                Container(
                  child: Center(
                    child: Text(
                      'belum ada event',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(height: 50),

                Text(
                  'Program Afiliasi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.AFFILIATE),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      'assets/afiliasiBanner.jpg',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //
                SizedBox(height: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bantuan Cepat',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildHelpContainer(
                          title: 'Hubungi Kami',
                          description:
                              'Punya pertanyaan atau bantuan? Silahkan hubungi kami.',
                          buttonText: 'Hubungi Kami',
                          onPressed: () {
                            controller.launchWhatsApp();
                          },
                        ),
                        SizedBox(width: 16),
                        _buildHelpContainer(
                          title: 'Panduan',
                          description:
                              'Pengguna baru? Silahkan baca panduan terlebih dahulu.',
                          buttonText: 'Panduan',
                          onPressed: () {
                            controller.launchHelp();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget _buildHelpContainer({
  required String title,
  required String description,
  required String buttonText,
  required VoidCallback onPressed, // callback tombol
}) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          SizedBox(height: 16),
          Divider(color: Colors.grey[400], height: 1),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed, // pakai callback
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF16A085),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildServiceCard(
  String icon,
  String title,
  Color color, {
  String? badge,
}) {
  return Stack(
    children: [
      Container(
        width: 100,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12), // biar ada ruang di sekitar icon
              decoration: BoxDecoration(
                color: color, // warna background teal
                borderRadius: BorderRadius.circular(5),
              ),
              child: SvgPicture.asset(icon),
            ),
            SizedBox(height: 8),
            Text(title, style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
      if (badge != null)
        Positioned(
          right: 0,
          top: 30,
          child: Container(
            width: 50,
            height: 25,
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(3),
                topStart: Radius.circular(3),
              ),
            ),
            child: Center(
              child: Text(
                badge,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ),
    ],
  );
}

Widget _buildCategoryItem(String title, String icon, String kategoriId) {
  return InkWell(
    onTap: () {
      Get.toNamed("/kategori", arguments: kategoriId);
    },
    child: Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center, // vertikal center
          crossAxisAlignment: CrossAxisAlignment.center, // horizontal center
          children: [
            Image.network(
              icon,
              width: 48,
              height: 48,
              fit: BoxFit.contain, // biar nggak ketarik aneh
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
