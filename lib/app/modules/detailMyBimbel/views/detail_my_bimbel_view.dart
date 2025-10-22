import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/modules/home/controllers/home_controller.dart';
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
        Get.offNamed(Routes.MY_BIMBEL);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "Detail Bimbel Saya",
          onBack: () => Get.offNamed(Routes.MY_BIMBEL),
        ),
        body: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.teal,
          onRefresh: () => controller.refresh(),
          child: Obx(() {
            var data = controller.bimbelData;
            return SafeArea(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
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
                          padding: EdgeInsets.all(16),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 4),
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
                              SizedBox(height: 12),

                              // ===== MASA AKTIF =====
                              Text(
                                'Masa Aktif',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),

                              // Progress Bar (mirip card tryout)
                              Builder(
                                builder: (context) {
                                  // Parse tanggal dari string (aman dari null & error format)
                                  DateTime? startDate;
                                  DateTime? endDate;

                                  try {
                                    final createdAt = data['created_at'];
                                    final expiredAt = data['expireddate'];
                                    print("xxx ${createdAt}");
                                    print("xxxv ${expiredAt}");

                                    if (createdAt != null &&
                                        expiredAt != null) {
                                      startDate =
                                          DateTime.tryParse(
                                            createdAt,
                                          )?.toLocal();
                                      endDate =
                                          DateTime.tryParse(
                                            expiredAt,
                                          )?.toLocal();
                                    }
                                  } catch (e) {
                                    debugPrint("Error parsing date: $e");
                                  }

                                  final now = DateTime.now();

                                  int totalDays = 1;
                                  int remainingDays = 0;

                                  if (startDate != null && endDate != null) {
                                    totalDays =
                                        endDate!.difference(startDate!).inDays;
                                    remainingDays =
                                        endDate!.difference(now).inDays;
                                  } else {
                                    totalDays = 0;
                                    remainingDays = 0;
                                  }

                                  // Hindari nilai negatif atau NaN
                                  final progress = ((remainingDays /
                                          (totalDays == 0 ? 1 : totalDays)))
                                      .clamp(0.0, 1.0);

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            "${((remainingDays ?? 0).isFinite ? (remainingDays ?? 0) : 0).clamp(0, (totalDays ?? 0) > 0 ? (totalDays ?? 0) : 9999)} Hari Lagi",
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
                              SizedBox(height: 16),

                              // ===== BUTTON UBAH PAKET =====
                              SizedBox(
                                width: double.infinity,
                                child: Obx(() {
                                  // cek apakah loading atau data kosong
                                  final isLoading =
                                      controller.bimbelBuyData.isEmpty;

                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          (controller.bimbelBuyData['bimbel']
                                                          as List?)
                                                      ?.any(
                                                        (item) =>
                                                            item['is_showing'] ==
                                                            true,
                                                      ) ==
                                                  true
                                              ? Colors.teal
                                              : Colors.grey[400],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed:
                                        isLoading
                                            ? null
                                            : ((controller.bimbelBuyData['bimbel']
                                                        as List?)
                                                    ?.any(
                                                      (item) =>
                                                          item['is_showing'] ==
                                                          true,
                                                    ) ==
                                                true)
                                            ? () {
                                              buildBuyBimbelDialog(
                                                context,
                                                controller,
                                              );
                                            }
                                            : null,
                                    child:
                                        isLoading
                                            ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : const Text(
                                              "Ganti Paket",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                  );
                                }),
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
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.teal,
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
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
                                  colorFilter: ColorFilter.mode(
                                    Colors.teal,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
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
                            final events = data['bimbel']?['events'];

                            if (events == null ||
                                (events is List && events.isEmpty)) {
                              notifHelper.show(
                                "Rekaman tidak tersedia",
                                type: 0,
                              );
                            } else {
                              Get.toNamed(
                                Routes.BIMBEL_RECORD,
                                arguments: events,
                              );
                            }
                          },

                          borderRadius: BorderRadius.circular(16),
                          splashColor: Colors.red.withOpacity(0.2),
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(
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
                                  offset: Offset(0, 3),
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
                                  colorFilter: ColorFilter.mode(
                                    Colors.red,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
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
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.blue,
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
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
                                  colorFilter: ColorFilter.mode(
                                    Colors.blue,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
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
                    controller.levelName.toLowerCase() == "basic"
                        ? const SizedBox.shrink() // kalau basic, tidak tampil
                        : controller.platinumZone.value
                        ? Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.teal),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text:
                                  'Anda terdaftar dalam program Platinum Zone, ayo manfaatkan fitur-fiturnya ',
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'disini',
                                  style: const TextStyle(
                                    color: Colors.teal,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap =
                                            () => Get.toNamed(
                                              Routes.PLATINUM_ZONE,
                                            ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : const SizedBox(),
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
                                                      (item['has_pretest'] ==
                                                                  false &&
                                                              item['can_pretest'] ==
                                                                  true)
                                                          ? () {
                                                            print(
                                                              "xxxv ${item['has_pretest']} dan ${item['can_pretest'].toString()}",
                                                            );
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
                                                    color:
                                                        (item['has_pretest'] ==
                                                                    false &&
                                                                item['can_pretest'] ==
                                                                    true)
                                                            ? Colors
                                                                .white // icon putih kalau aktif
                                                            : Colors
                                                                .grey
                                                                .shade600, // icon abu kalau disable
                                                  ),
                                                  label: Text(
                                                    'Pretest',
                                                    style: TextStyle(
                                                      color:
                                                          (item['has_pretest'] ==
                                                                      false &&
                                                                  item['can_pretest'] ==
                                                                      true)
                                                              ? Colors
                                                                  .white // teks putih kalau aktif
                                                              : Colors
                                                                  .grey
                                                                  .shade600, // teks abu kalau disable
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        (item['has_pretest'] ==
                                                                    false &&
                                                                item['can_pretest'] ==
                                                                    true)
                                                            ? Colors
                                                                .amber // kuning kalau aktif
                                                            : Colors
                                                                .grey
                                                                .shade300, // abu-abu kalau disable
                                                    side: BorderSide(
                                                      color:
                                                          (item['has_pretest'] ==
                                                                      false &&
                                                                  item['can_pretest'] ==
                                                                      true)
                                                              ? Colors
                                                                  .amber
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                    minimumSize: Size(0, 40),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 8),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed:
                                                      (item['url'] != null &&
                                                              item['url']
                                                                  .toString()
                                                                  .isNotEmpty)
                                                          ? () async {
                                                            final url =
                                                                item['url']
                                                                    .toString();
                                                            if (await canLaunchUrl(
                                                              Uri.parse(url),
                                                            )) {
                                                              await launchUrl(
                                                                Uri.parse(url),
                                                                mode:
                                                                    LaunchMode
                                                                        .externalApplication,
                                                              );
                                                            }
                                                          }
                                                          : null, // disable kalau url null/kosong
                                                  icon: Icon(
                                                    Icons.video_call,
                                                    size: 18,
                                                    color:
                                                        (item['url'] != null &&
                                                                item['url']
                                                                    .toString()
                                                                    .isNotEmpty)
                                                            ? Colors
                                                                .white // icon putih kalau aktif
                                                            : Colors
                                                                .grey
                                                                .shade700, // icon abu kalau disable
                                                  ),
                                                  label: Text(
                                                    'Buka Kelas',
                                                    style: TextStyle(
                                                      color:
                                                          (item['url'] !=
                                                                      null &&
                                                                  item['url']
                                                                      .toString()
                                                                      .isNotEmpty)
                                                              ? Colors
                                                                  .white // teks putih kalau aktif
                                                              : Colors
                                                                  .grey
                                                                  .shade700, // teks abu kalau disable
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        (item['url'] != null &&
                                                                item['url']
                                                                    .toString()
                                                                    .isNotEmpty)
                                                            ? Colors
                                                                .teal // aktif
                                                            : Colors
                                                                .grey
                                                                .shade100, // non-aktif
                                                    side: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                                        (item['has_pretest'] == false &&
                                                item['can_pretest'] == true)
                                            // 1 == 1
                                            ? () {
                                              Get.toNamed(
                                                Routes.PRETEST_DETAIL,
                                                arguments: {
                                                  "item": item,
                                                  "uuidParent":
                                                      controller
                                                          .bimbelData['uuid'],
                                                },
                                              );
                                              print("xxx ${item.toString()}");
                                            }
                                            : null, // null = tombol disabled

                                    icon: Icon(
                                      Icons.assignment,
                                      size: 18,
                                      color:
                                          (item['has_pretest'] == false &&
                                                  item['can_pretest'] == true)
                                              ? Colors
                                                  .white // icon putih kalau aktif
                                              : Colors
                                                  .grey
                                                  .shade600, // icon abu kalau disable
                                    ),
                                    label: Text(
                                      'Pretest',
                                      style: TextStyle(
                                        color:
                                            (item['has_pretest'] == false &&
                                                    item['can_pretest'] == true)
                                                ? Colors
                                                    .white // teks putih kalau aktif
                                                : Colors
                                                    .grey
                                                    .shade600, // teks abu kalau disable
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          (item['has_pretest'] == false &&
                                                  item['can_pretest'] == true)
                                              ? Colors
                                                  .amber // kuning kalau aktif
                                              : Colors
                                                  .grey
                                                  .shade300, // abu-abu kalau disable
                                      side: BorderSide(
                                        color:
                                            (item['has_pretest'] == false &&
                                                    item['can_pretest'] == true)
                                                ? Colors.amber.shade700
                                                : Colors.grey.shade300,
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
                                    onPressed:
                                        (item['url'] != null &&
                                                item['url']
                                                    .toString()
                                                    .isNotEmpty)
                                            ? () async {
                                              final url =
                                                  item['url'].toString();
                                              if (await canLaunchUrl(
                                                Uri.parse(url),
                                              )) {
                                                await launchUrl(
                                                  Uri.parse(url),
                                                  mode:
                                                      LaunchMode
                                                          .externalApplication,
                                                );
                                              } else {
                                                notifHelper.show(
                                                  "Tidak bisa membuka link",
                                                  type: 0,
                                                );
                                              }
                                            }
                                            : null,
                                    icon: Icon(
                                      Icons.video_call,
                                      size: 18,
                                      color:
                                          (item['url'] != null &&
                                                  item['url']
                                                      .toString()
                                                      .isNotEmpty)
                                              ? Colors
                                                  .white // icon putih kalau aktif
                                              : Colors
                                                  .grey
                                                  .shade700, // icon abu kalau disable
                                    ),
                                    label: Text(
                                      'Buka Kelas',
                                      style: TextStyle(
                                        color:
                                            (item['url'] != null &&
                                                    item['url']
                                                        .toString()
                                                        .isNotEmpty)
                                                ? Colors
                                                    .white // teks putih kalau aktif
                                                : Colors
                                                    .grey
                                                    .shade700, // teks abu kalau disable
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          (item['url'] != null &&
                                                  item['url']
                                                      .toString()
                                                      .isNotEmpty)
                                              ? Colors
                                                  .teal // aktif
                                              : Colors
                                                  .grey
                                                  .shade100, // non-aktif
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
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void buildBuyBimbelDialog(
    BuildContext context,
    DetailMyBimbelController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pilih Bimbel",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // 🔽 Pakai fungsi _buildRadioOption
                Column(
                  children: [
                    for (
                      int i = 0;
                      i < controller.bimbelBuyData['bimbel'].length;
                      i++
                    )
                      Obx(() {
                        print(
                          controller.bimbelBuyData['bimbel'].length.toString(),
                        );
                        final subData = controller.bimbelBuyData['bimbel'][i];

                        // filter paket yang sedang ditampilkan
                        if (!(subData['is_showing'] ?? false)) {
                          return SizedBox.shrink();
                        }

                        // index paket pertama yang sudah dibeli
                        final firstPurchasedIndex = controller
                            .bimbelBuyData['bimbel']
                            .indexWhere((e) => e['is_purchase'] == true);

                        // skip paket yang lebih murah dari paket yang sudah dibeli
                        if (firstPurchasedIndex != -1 &&
                            i < firstPurchasedIndex) {
                          return SizedBox.shrink();
                        }

                        // harga yang ditampilkan dikurangi harga paket yang sudah dibeli

                        final hargaTampil = controller.hitungHargaTampil(
                          subData,
                          i,
                          controller.bimbelBuyData['bimbel'],
                        );

                        // disable jika paket sudah dibeli
                        final isDisabled =
                            (firstPurchasedIndex != -1 &&
                                i == firstPurchasedIndex);
                        print("xxx ${subData['uuid'].toString()}");
                        return _buildRadioOption(
                          subData['name'], // title
                          formatRupiah(subData['harga']), // harga lama
                          hargaTampil.toString(), // harga baru
                          subData['uuid'], // value radio
                          controller, // controller
                          isDisabled: isDisabled, // disable jika sudah dibeli
                        );
                      }),
                  ],
                ),
                SizedBox(height: 16),

                // Tombol Lanjutkan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (controller.selectedPaket.value == "") {
                        notifHelper.show(
                          "Silakan pilih paket terlebih dahulu.",
                          type: 0,
                        );
                        return;
                      }
                      // hargaFix.value,
                      // paketBimbelData,
                      // paymentData,
                      // otherBimbelData,
                      // Get.toNamed(
                      //   Routes.PAYMENT_DETAIL,
                      //   arguments: [
                      //     controller.hargaFix.value,
                      //     controller.selectedPaket.value,
                      //   ],
                      // );
                      controller.getDataChangePaket();
                    },
                    child: Text(
                      "Lanjutkan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRadioOption(
    String title,
    String oldPrice,
    String newPrice,
    String uuid,
    DetailMyBimbelController controller, {
    bool isDisabled = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kiri: Radio + Title (dibungkus Expanded biar gak dorong kanan keluar)
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Radio<String>(
                    value: uuid,
                    groupValue: controller.selectedPaket.value,
                    onChanged:
                        isDisabled
                            ? null
                            : (value) {
                              if (value != null) {
                                controller.pilihPaket(value);
                                controller.hargaFix.value = int.parse(newPrice);
                              }
                            },
                    activeColor: Colors.teal,
                  ),
                ),
                // Judul paket (wrap text kalau kepanjangan)
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 14),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // batasi 2 baris biar rapih
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8),

          // Kanan: Harga (dibungkus Flexible supaya wrap atau shrink)
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  oldPrice,
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4),
                if (!isDisabled)
                  Text(
                    formatRupiah(newPrice),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
