import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

import '../controllers/detail_my_bimbel_controller.dart';

class DetailMyBimbelView extends GetView<DetailMyBimbelController> {
  const DetailMyBimbelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Detail Bimbel Saya',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.notifications_none, color: Colors.teal),
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '9+',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(
        () => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================== INFO PAKET ==================
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.paketName.value,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        controller.paketType.value,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text('Masa Aktif'),
                      SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          minimumSize: Size.fromHeight(35),
                        ),
                        onPressed: () {},
                        child: Text(
                          '${controller.masaAktif.value} Hari Lagi',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.fromHeight(40),
                          backgroundColor: Colors.teal, // warna background
                          foregroundColor: Colors.white, // warna teks & icon
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // border radius 8
                          ),
                        ),
                        child: Text('Ganti Paket'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // ================== MENU BUTTONS ==================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icon/iconBuku.svg',
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(height: 8),
                            Text('Materi'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.BIMBEL_RECORD);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icon/iconRekaman.svg',
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(height: 8),
                            Text('Rekaman'),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icon/iconPesawatKertas.svg',
                              width: 50,
                              height: 50,
                            ),
                            SizedBox(height: 8),
                            Text('Group'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // ================== PLATINUM INFO ==================
                controller.platinumZone.value
                    ? Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.teal),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text:
                              'Anda terdaftar dalam program Platinum Zone, ayo manfaatkan fitur-fiturnya ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'disini',
                              style: TextStyle(
                                color: Colors.teal,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : SizedBox(),
                SizedBox(height: 16),

                // ================== PERINGKAT ==================
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Peringkat',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.PRETEST_RANKING);
                            },
                            child: Text(
                              'Lihat Ranking',
                              style: TextStyle(color: Colors.teal),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "1", // ranking kamu
                                style: TextStyle(
                                  color: Colors.black, // highlight hitam
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                ),
                              ),
                              TextSpan(
                                text: "/0", // total peserta
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 23,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // ================== KELAS HARI INI ==================
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kelas Hari Ini',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "judul",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Hari",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text("hari"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Tanggal",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text("tanggal"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Jam",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text("jam"),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),

                            // Tombol Pretest + Buka Kelas (inline)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Get.toNamed(Routes.PRETEST_DETAIL);
                                    },
                                    icon: Icon(Icons.assignment, size: 18),
                                    label: Text('Pretest'),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.grey.shade100,
                                      foregroundColor: Colors.grey.shade700,
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
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
                                    icon: Icon(Icons.video_call, size: 18),
                                    label: Text('Buka Kelas'),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.grey.shade100,
                                      foregroundColor: Colors.grey.shade700,
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
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
                      // Text('Hari ini tidak ada kelas'),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // ================== JADWAL BIMBEL (LOOPING) ==================
                Text(
                  'Jadwal Kelas Bimbel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                ...controller.jadwalKelas.map(
                  (item) => Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['judul']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Hari",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(item['hari']!),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Tanggal",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(item['tanggal']!),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Jam",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(item['jam']!),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 12),

                        // Tombol Pretest + Buka Kelas (inline)
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Get.toNamed(Routes.PRETEST_DETAIL);
                                },
                                icon: Icon(Icons.assignment, size: 18),
                                label: Text('Pretest'),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.grey.shade100,
                                  foregroundColor: Colors.grey.shade700,
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
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
                                icon: Icon(Icons.video_call, size: 18),
                                label: Text('Buka Kelas'),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.grey.shade100,
                                  foregroundColor: Colors.grey.shade700,
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  minimumSize: Size(0, 40),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
