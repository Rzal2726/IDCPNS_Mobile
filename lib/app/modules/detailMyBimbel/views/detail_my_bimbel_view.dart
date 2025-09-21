import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/detail_my_bimbel_controller.dart';

class DetailMyBimbelView extends GetView<DetailMyBimbelController> {
  const DetailMyBimbelView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // biar kita handle manual
      onPopInvoked: (didPop) async {
        if (didPop) return;
        // Arahkan tombol back fisik HP ke halaman BIMBEL
        Get.toNamed(Routes.MY_BIMBEL);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "Detail Bimbel Saya",
          onBack: () => Get.toNamed(Routes.MY_BIMBEL),
        ),
        body: Obx(() {
          var data = controller.bimbelData;
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================== INFO PAKET ==================
                  Skeletonizer(
                    enabled:
                        data.isEmpty, // aktifin skeleton kalau data belum ada
                    child: Card(
                      color: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ===== NAMA BIMBEL =====
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Skeleton.replace(
                                  child: Text(
                                    data['bimbel']?['bimbel_parent']?['name'] ??
                                        '██████████',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Skeleton.replace(
                                  child: Text(
                                    data['bimbel']?['name'] ?? '███████',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // ===== MASA AKTIF =====
                            const Text(
                              'Masa Aktif',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Progress Bar (mirip card tryout)
                            Builder(
                              builder: (context) {
                                final totalDays =
                                    data['bimbel']?['total_day'] ??
                                    1; // pastikan ga 0 biar ga error
                                final remainingDays =
                                    data['bimbel']?['reamining_day'] ?? 0;
                                final progress = (remainingDays / totalDays)
                                    .clamp(0.0, 1.0);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.grey.shade300,
                                      color: Colors.teal.shade300,
                                      minHeight: 12,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Sisa Hari',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          "$remainingDays Hari Lagi",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            // ===== BUTTON UBAH PAKET =====
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  // Fungsi lama dipertahankan
                                },
                                child: const Text(
                                  "Ganti Paket",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // ================== MENU BUTTONS ==================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ====== Tombol Materi ======
                      InkWell(
                        onTap: () async {
                          final url = Uri.parse(
                            "${data['bimbel']['link_materi']}",
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            throw "Tidak bisa buka $url";
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        splashColor: Colors.teal.withOpacity(0.2),
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.teal, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icon/iconBuku.svg',
                                width: 36,
                                height: 36,
                                colorFilter: const ColorFilter.mode(
                                  Colors.teal,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Materi',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ====== Tombol Rekaman ======
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.BIMBEL_RECORD,
                            arguments: data['bimbel']['events'],
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        splashColor: Colors.red.withOpacity(0.2),
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.red, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icon/iconRekaman.svg',
                                width: 36,
                                height: 36,
                                colorFilter: const ColorFilter.mode(
                                  Colors.red,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Rekaman',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ====== Tombol Group ======
                      InkWell(
                        onTap: () async {
                          final url = Uri.parse(
                            "${data['bimbel']['link_grup']}",
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            throw "Tidak bisa buka $url";
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        splashColor: Colors.blue.withOpacity(0.2),
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue, width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icon/iconPesawatKertas.svg',
                                width: 36,
                                height: 36,
                                colorFilter: const ColorFilter.mode(
                                  Colors.blue,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Group',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // ================== PLATINUM INFO ==================
                  controller.platinumZone.value == true
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
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.toNamed(
                                          Routes.PLATINUM_ZONE,
                                        ); // ganti dengan rute kamu
                                      },
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
                                Get.toNamed(
                                  Routes.PRETEST_RANKING,
                                  arguments: data['uuid'],
                                );
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
                          child: Skeleton.replace(
                            replace:
                                controller
                                    .rankBimbel
                                    .isEmpty, // skeleton aktif saat data kosong
                            replacement: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 40,
                                  height: 24,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(width: 4),
                                Container(
                                  width: 40,
                                  height: 24,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: controller.userRank.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "/${controller.rankBimbel['data']?.length ?? 0}",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 23,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // ================== KELAS HARI INI ==================
                  controller.jadwalKelasIsRunning.isNotEmpty
                      ? Container(
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
                            ...controller.jadwalKelasIsRunning
                                .map(
                                  (item) => Container(
                                    margin: EdgeInsets.only(bottom: 12),
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
                                          item['judul']!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 12),
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
                                                  item['jadwal_tanggal']['hari']!,
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
                                                  item['jadwal_tanggal']['tanggal']!,
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
                                                  item['jadwal_tanggal']['jam']!,
                                                ),
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
                                                onPressed:
                                                    item['can_pretest'] == true
                                                        ? () {
                                                          Get.toNamed(
                                                            Routes
                                                                .PRETEST_DETAIL,
                                                            arguments: {
                                                              "item": item,
                                                              "uuidParent":
                                                                  controller
                                                                      .bimbelData['uuid'],
                                                            },
                                                          );
                                                          print(
                                                            "xxx ${item.toString()}",
                                                          );
                                                        }
                                                        : null, // null = tombol disabled
                                                icon: Icon(
                                                  Icons.assignment,
                                                  size: 18,
                                                ),
                                                label: Text('Pretest'),
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      item['can_pretest'] ==
                                                              true
                                                          ? Colors.teal
                                                          : Colors
                                                              .grey
                                                              .shade300, // abu-abu kalau disabled
                                                  foregroundColor:
                                                      item['can_pretest'] ==
                                                              true
                                                          ? Colors.white
                                                          : Colors
                                                              .grey
                                                              .shade600,
                                                  side: BorderSide(
                                                    color:
                                                        item['can_pretest'] ==
                                                                true
                                                            ? Colors
                                                                .teal
                                                                .shade700
                                                            : Colors
                                                                .grey
                                                                .shade300,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
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
                                                  Icons.video_call,
                                                  size: 18,
                                                ),
                                                label: Text('Buka Kelas'),
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.grey.shade100,
                                                  foregroundColor:
                                                      Colors.grey.shade700,
                                                  side: BorderSide(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
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
                                )
                                .toList(),
                          ],
                        ),
                      )
                      : SizedBox.shrink(), // kalau kosong, widget ini ga muncul

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
                                  Text(item['jadwal_tanggal']['hari']!),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Tanggal",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(item['jadwal_tanggal']['tanggal']!),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Jam",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(item['jadwal_tanggal']['jam']!),
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
                                  onPressed:
                                      item['can_pretest'] == true
                                          ? () {
                                            Get.toNamed(
                                              Routes.PRETEST_DETAIL,
                                              arguments: {
                                                "item": data,
                                                "uuidParent": data['uuid'],
                                              },
                                            );
                                          }
                                          : null, // null = tombol disabled
                                  icon: Icon(Icons.assignment, size: 18),
                                  label: Text('Pretest'),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor:
                                        item['can_pretest'] == true
                                            ? Colors.teal
                                            : Colors
                                                .grey
                                                .shade300, // abu-abu kalau disabled
                                    foregroundColor:
                                        item['can_pretest'] == true
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                    side: BorderSide(
                                      color:
                                          item['can_pretest'] == true
                                              ? Colors.teal.shade700
                                              : Colors.grey.shade300,
                                    ),
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
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
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
          );
        }),
      ),
    );
  }
}
