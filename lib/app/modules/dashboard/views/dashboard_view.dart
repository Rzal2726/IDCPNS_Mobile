import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/emptyDataWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/exitDialog.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/Components/widgets/programTryoutGratisCard.dart';
import 'package:idcpns_mobile/app/Components/widgets/wdigetTryoutEventCard.dart';
import 'package:idcpns_mobile/app/modules/detail_tryout_saya/controllers/detail_tryout_saya_controller.dart';
import 'package:idcpns_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // biar kita yang kontrol back nya
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final homeC = Get.find<HomeController>();
          if (homeC.currentIndex.value == 0) {
            final keluar = await showExitDialog(context);
            if (keluar) {
              SystemNavigator.pop();
            }
          } else {
            homeC.changeBottomBar(0);
            homeC.currentIndex.value = 0;
          }
        }
      },
      child: Scaffold(
        appBar: basicAppBar(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.teal,

            onRefresh: () => controller.initScreen(),
            child: Obx(() {
              var data = controller.tryoutRecomHomeData;
              var recoData = controller.recomenData;
              return SingleChildScrollView(
                padding: AppStyle.sreenPaddingHome,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Highlight Section
                    Text(
                      'Highlight',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8), // kasih jarak biar gak terlalu nempel
                    Divider(
                      thickness: 0.2,
                      color: Colors.grey, // bisa diganti kalau mau lebih soft
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 150, // tinggi carousel
                      width: double.infinity,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration: Duration(
                            milliseconds: 1000,
                          ),
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                        ),
                        items: [
                          for (var banner in controller.bannerData)
                            GestureDetector(
                              onTap: () async {
                                if (!banner.containsKey('link_mobile') ||
                                    banner['link_mobile'] == null ||
                                    banner['link_mobile'].isEmpty) {
                                  return;
                                }

                                final url = banner['link_mobile']!;
                                final isUrl =
                                    banner.containsKey('is_url') &&
                                    banner['is_url'] == "1";

                                if (isUrl) {
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(
                                      uri,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {}
                                } else {
                                  Get.toNamed(url, arguments: banner['params']);
                                }
                              },

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Skeletonizer(
                                  enabled:
                                      banner['gambar'] == null ||
                                      banner['gambar']!.isEmpty,
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Image.network(
                                        banner['gambar']!,
                                        // opsional, agar image sesuai height
                                        fit: BoxFit.cover, // biar menutupi area
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Center(
                                            child: Icon(Icons.broken_image),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    controller.bimbelRemainder.isNotEmpty
                        ? Column(
                          children: [
                            for (var data in controller.bimbelRemainder)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pengingat Bimbel",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Divider(
                                    thickness: 0.2,
                                    color:
                                        Colors
                                            .grey, // bisa diganti kalau mau lebih soft
                                  ),
                                  SizedBox(height: 30),
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
                                                onPressed:
                                                    (data['has_pretest'] ==
                                                            false)
                                                        ? () async {
                                                          final uuid =
                                                              data['uuid']
                                                                  ?.toString() ??
                                                              '';
                                                          final eventUuid =
                                                              data['event_uuid']
                                                                  ?.toString() ??
                                                              '';

                                                          if (uuid.isEmpty ||
                                                              eventUuid
                                                                  .isEmpty) {
                                                            notifHelper.show(
                                                              'Data tidak lengkap',
                                                              type: 0,
                                                            );
                                                            return;
                                                          }

                                                          // optional: tampilkan loading sementara nge-fetch
                                                          Get.dialog(
                                                            Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                            barrierDismissible:
                                                                false,
                                                          );

                                                          try {
                                                            final detail =
                                                                await controller
                                                                    .getDetailBimbel(
                                                                      uuid:
                                                                          uuid,
                                                                      eventUuid:
                                                                          eventUuid,
                                                                    );

                                                            // tutup loading
                                                            if (Get.isDialogOpen ??
                                                                false)
                                                              Get.back();

                                                            if (detail ==
                                                                null) {
                                                              notifHelper.show(
                                                                'Detail pretest tidak ditemukan',
                                                                type: 0,
                                                              );
                                                              return;
                                                            }

                                                            Get.toNamed(
                                                              Routes
                                                                  .PRETEST_DETAIL,
                                                              arguments: {
                                                                'item': detail,
                                                                'uuidParent':
                                                                    uuid,
                                                              },
                                                            );
                                                          } catch (e) {
                                                            if (Get.isDialogOpen ??
                                                                false)
                                                              Get.back();
                                                            notifHelper.show(
                                                              'Terjadi kesalahan',
                                                              type: 0,
                                                            );
                                                          }
                                                        }
                                                        : null,

                                                icon: Icon(
                                                  Icons.assignment,
                                                  size: 18,
                                                ),
                                                label: Text('Pretest'),
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor: Colors.amber,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                  ),
                                                  minimumSize: Size(0, 40),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed:
                                                    (data['url'] != null &&
                                                            data['url']
                                                                .toString()
                                                                .isNotEmpty)
                                                        ? () async {
                                                          final url =
                                                              data['url']
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
                                                        : null, // tombol disable kalau url null/kosong
                                                icon: Icon(
                                                  Icons.computer,
                                                  size: 18,
                                                  color:
                                                      (data['url'] != null &&
                                                              data['url']
                                                                  .toString()
                                                                  .isNotEmpty)
                                                          ? Colors.white
                                                          : Colors
                                                              .grey
                                                              .shade600,
                                                ),
                                                label: Text(
                                                  'Buka Kelas',
                                                  style: TextStyle(
                                                    color:
                                                        (data['url'] != null &&
                                                                data['url']
                                                                    .toString()
                                                                    .isNotEmpty)
                                                            ? Colors.white
                                                            : Colors
                                                                .grey
                                                                .shade600,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      (data['url'] != null &&
                                                              data['url']
                                                                  .toString()
                                                                  .isNotEmpty)
                                                          ? Colors
                                                              .teal // aktif
                                                          : Colors
                                                              .grey
                                                              .shade300, // non-aktif
                                                  side: BorderSide(
                                                    color:
                                                        (data['url'] != null &&
                                                                data['url']
                                                                    .toString()
                                                                    .isNotEmpty)
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
                                                    vertical: 8,
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
                                  SizedBox(height: 50),
                                ],
                              ),
                          ],
                        )
                        : SizedBox.shrink(),

                    // Pilih Layanan
                    Text(
                      'Pilih Layanan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('Pilih layanan yang cocok sebagai teman belajar kamu'),
                    SizedBox(height: 8), // kasih jarak biar gak terlalu nempel
                    Divider(
                      thickness: 0.2,
                      color: Colors.grey, // bisa diganti kalau mau lebih soft
                    ),
                    SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              (Get.find<HomeController>()).changeBottomBar(1);
                              (Get.find<HomeController>()).currentIndex.value =
                                  1;
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
                          child: GestureDetector(
                            onTap: () {
                              (Get.find<HomeController>()).changeBottomBar(2);
                              (Get.find<HomeController>()).currentIndex.value =
                                  2;
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
                          child: GestureDetector(
                            onTap: () {
                              (Get.find<HomeController>()).changeBottomBar(3);
                              (Get.find<HomeController>()).currentIndex.value =
                                  3;
                            },
                            child: _buildServiceCard(
                              'assets/platinumHomeIcon.svg',
                              'Platinum',
                              Colors.orange,
                              badge: 'Baru',
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 50),

                    // Pilih Kategori
                    Text(
                      'Pilih Kategori',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      style: TextStyle(color: Colors.grey),
                      'Pilih kategori yang cocok sebagai teman belajar kamu',
                    ),
                    SizedBox(height: 8), // kasih jarak biar gak terlalu nempel
                    Divider(
                      thickness: 0.2,
                      color: Colors.grey, // bisa diganti kalau mau lebih soft
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
                      child: Skeletonizer(
                        enabled:
                            controller
                                .kategoriData
                                .isEmpty, // aktifkan skeleton kalau data kosong
                        child: GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children:
                              controller.kategoriData.isEmpty
                                  ? List.generate(
                                    6, // jumlah placeholder skeleton
                                    (index) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )
                                  : [
                                    for (
                                      int i = 0;
                                      i < controller.kategoriData.length;
                                      i++
                                    )
                                      _buildCategoryItem(
                                        controller.kategoriData[i]['menu'],
                                        controller.kategoriData[i]['logo'],
                                        controller.kategoriData[i]['id']
                                            .toString(),
                                      ),
                                  ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50),

                    Obx(() {
                      return recoData['menu'] == null
                          ? Skeletonizer(
                            child: Text(
                              'Rekomendasi Penunjang Program lorem',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : Text(
                            'Rekomendasi Penunjang Program ${recoData['menu']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                    }),

                    SizedBox(height: 4),
                    Text(
                      style: TextStyle(color: Colors.grey),
                      'Pilihan utama kami untuk anda',
                    ),
                    SizedBox(height: 8), // kasih jarak biar gak terlalu nempel
                    Divider(
                      thickness: 0.2,
                      color: Colors.grey, // bisa diganti kalau mau lebih soft
                    ),
                    SizedBox(height: 30),
                    recoData['tryout_formasi'] != null
                        ? Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  Routes.DETAIL_TRYOUT,
                                  arguments: recoData['tryout_formasi']["uuid"],
                                );
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
                                          '${recoData['tryout_formasi']['gambar']}',
                                        ),
                                      ),
                                    ),

                                    // Area gambar dengan background dan icon dummy
                                    SizedBox(height: 16),
                                    // Judul "Platinum"
                                    Text(
                                      '${recoData['tryout_formasi']['formasi']}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),

                                    // Deskripsi
                                    Text(
                                      'Siap bersaing bersama ribuan peserta seleksi Rekrutmen Bersama ${recoData['menu']} lainnya! Ayo persiapkan diri kamu untuk seleksi ${recoData['menu']} selanjutnya dari sekarang dengan mengikuti ${recoData['tryout_formasi']['formasi']} dari ${recoData['menu']} ini.',
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

                    recoData['bimbel_parent'] != null
                        ? GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              Routes.DETAIL_BIMBEL,
                              arguments: recoData['bimbel_parent']['uuid'],
                            );
                          },
                          child: Column(
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
                                          '${recoData['bimbel_parent']['gambar']}',
                                        ),
                                      ),
                                    ),

                                    // Area gambar dengan background dan icon dummy
                                    SizedBox(height: 16),
                                    // Judul "Platinum"
                                    Text(
                                      '${recoData['bimbel_parent']['name']}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),

                                    // Deskripsi
                                    Text(
                                      'Siap bersaing bersama ribuan peserta seleksi Rekrutmen Bersama ${recoData['menu']} lainnya! Ayo persiapkan diri kamu untuk seleksi ${recoData['menu']} selanjutnya dari sekarang dengan mengikuti ${recoData['bimbel_parent']['formasi']} dari ${recoData['menu']} ini.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 16),

                                    // Harga coret
                                    Text(
                                      "${formatRupiah(recoData['bimbel_parent']['price_list']['harga_terendah'])} - ${formatRupiah(recoData['bimbel_parent']['price_list']['harga_tertinggi'])}",
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
                                      "${formatRupiah(recoData['bimbel_parent']['price_list']['harga_fix_terendah'])} - ${formatRupiah(recoData['bimbel_parent']['price_list']['harga_fix_tertinggi'])}",
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
                          ),
                        )
                        : SizedBox.shrink(),
                    recoData['upgrade'] != null
                        ? GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.UPGRADE_AKUN);
                          },
                          child: Column(
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
                                            recoData['upgrade']['gambar'] ==
                                                    null
                                                ? Image.asset(
                                                  'assets/squareLogo.png',
                                                )
                                                : Image.network(
                                                  '${recoData['upgrade']['gambar']}',
                                                ),
                                      ),
                                    ),

                                    // Area gambar dengan background dan icon dummy
                                    SizedBox(height: 16),
                                    // Judul "Platinum"
                                    Text(
                                      '${recoData['upgrade']['name']}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
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
                                      "${formatRupiah(recoData['upgrade']['price_list']['harga_terendah'])} - ${formatRupiah(recoData['upgrade']['price_list']['harga_tertinggi'])}",
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
                                      "${formatRupiah(recoData['upgrade']['price_list']['harga_fix_terendah'])} - ${formatRupiah(recoData['upgrade']['price_list']['harga_fix_tertinggi'])}",
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
                          ),
                        )
                        : SizedBox.shrink(),

                    SizedBox(height: 50),

                    Column(
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
                          'Ikuti tryout akbar gratis bersama ribuan peserta lainnya.',
                        ),
                        SizedBox(
                          height: 8,
                        ), // kasih jarak biar gak terlalu nempel
                        Divider(
                          thickness: 0.2,
                          color:
                              Colors.grey, // bisa diganti kalau mau lebih soft
                        ),
                        SizedBox(height: 20),

                        // Search field
                        Container(
                          height: 50,

                          child: TextField(
                            controller: controller.tryoutSearch,
                            onChanged: (value) {
                              controller.filterTryout(
                                query: controller.tryoutSearch.text,
                              );
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ), // Sesuaikan nilai vertical
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: 'Cari',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Tombol Filter
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              showFilterCategoryBottomSheet(context);
                            },
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
                        SizedBox(height: 10),
                        controller.tryoutEventLoading.value
                            ? Skeletonizer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: SizedBox(
                                            width: 300,
                                            child: buildTryoutCard(
                                              dateRange: 'lorem',
                                              period: "lorem",
                                              status: 'lorem',
                                              title: 'lorem ipsum',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : controller.tryoutEventFilterData.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/emptyArchiveIcon.svg",
                                    width: 140, // atur lebar
                                    height: 140, // atur tinggi
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Belum Ada Event Berlangsung',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Scrollable Row
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for (var data
                                          in controller.tryoutEventFilterData)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: SizedBox(
                                            width:
                                                300, // biar card rapi & konsisten
                                            child: GestureDetector(
                                              onTap: () {
                                                final isVerification =
                                                    parseBoolNullable(
                                                      data['is_verification'],
                                                    );
                                                if (data['is_purchase']) {
                                                  if (isVerification != null &&
                                                      isVerification) {
                                                    Get.toNamed(
                                                      "/detail-event",
                                                      arguments: data['uuid'],
                                                    );
                                                    return;
                                                  }
                                                  Get.delete<
                                                    DetailTryoutSayaController
                                                  >(force: true);
                                                  Get.toNamed(
                                                    "/detail-tryout-saya",
                                                    arguments:
                                                        data['tryout_transaction_id'],
                                                  );
                                                } else {
                                                  Get.toNamed(
                                                    "/detail-event",
                                                    arguments: data['uuid'],
                                                  );
                                                }
                                              },
                                              child: buildTryoutCard(
                                                status: data['label_text'],
                                                title: data['name'],
                                                dateRange:
                                                    data['range_date_string'],
                                                period: data['periode_text'],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Indikasi scroll
                                Visibility(
                                  visible:
                                      (controller
                                              .tryoutEventFilterData
                                              ?.length ??
                                          0) >
                                      1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.swipe,
                                        size: 16,
                                        color: Colors.black38,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Geser untuk lihat lainnya",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black38,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rekomendasi Tryout',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Ikuti event tryout dari rekomendasi kita untuk anda!',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 8,
                        ), // kasih jarak biar gak terlalu nempel
                        Divider(
                          thickness: 0.2,
                          color:
                              Colors.grey, // bisa diganti kalau mau lebih soft
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    controller.tryoutRecomHomeData.isNotEmpty
                        ? buildRecomenTryoutCard(
                          onPressed: () {
                            Get.toNamed(
                              Routes.DETAIL_EVENT,
                              arguments: data['uuid'],
                            );
                          },
                          title: data['name'],
                          periode: data['range_date_string'],
                          type: "x",
                        )
                        : controller.tryoutRecommendLoading.value
                        ? Skeletonizer(
                          child: buildRecomenTryoutCard(
                            onPressed: () {},
                            title: "lorem ipsum",
                            periode: "lorem ipsum",
                            type: "lorem",
                          ),
                        )
                        : EmptyStateWidget(message: "Belum ada event"),

                    SizedBox(height: 50),

                    Text(
                      'Program Afiliasi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8), // kasih jarak biar gak terlalu nempel
                    Divider(
                      thickness: 0.2,
                      color: Colors.grey, // bisa diganti kalau mau lebih soft
                    ),
                    SizedBox(height: 30),

                    GestureDetector(
                      onTap: () => Get.offNamed(Routes.AFFILIATE),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/afiliasiBanner.jpg',
                          fit: BoxFit.fill,
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
                        SizedBox(
                          height: 8,
                        ), // kasih jarak biar gak terlalu nempel
                        Divider(
                          thickness: 0.2,
                          color:
                              Colors.grey, // bisa diganti kalau mau lebih soft
                        ),
                        SizedBox(height: 30),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildHelpContainer(
                                title: 'Hubungi Kami',
                                description:
                                    'Punya pertanyaan atau bantuan? Silahkan hubungi kami. ',
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
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

Widget _buildHelpContainer({
  required String title,
  required String description,
  required String buttonText,
  required VoidCallback onPressed,
}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        8,
      ), // 🔥 kasih space bawah dikit (8px)
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.black54),
                softWrap: true,
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(color: Colors.grey[400], height: 1),
          SizedBox(height: 10), //
          Padding(
            padding: const EdgeInsets.only(bottom: 4), // jarak bawah tipis
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A085),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
        width: 120,
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
  return GestureDetector(
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

void showFilterCategoryBottomSheet(BuildContext context) {
  final controller = Get.put(DashboardController());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: MediaQuery.of(ctx).viewInsets,
              child: Container(
                color: Colors.white,
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
                          "Jenis Bimbel",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // List pilihan dengan ChoiceChip
                    Obx(
                      () => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            controller.options.map((option) {
                              final isSelected =
                                  controller.selectedKategoriId.value ==
                                  option['id'];

                              return ChoiceChip(
                                label: Text(
                                  option['menu'], // tampilkan name
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.teal
                                            : Colors.grey[700],
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: Colors.teal.withOpacity(0.1),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color:
                                        isSelected
                                            ? Colors.teal
                                            : Colors.grey.shade400,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                onSelected: (value) {
                                  print("xxxz ${option['id'].toString()}");
                                  controller.selectedKategoriId.value =
                                      option['id'];
                                  controller.selectedEventKategori.value =
                                      option['menu'];
                                },
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Tombol cari
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          controller.filterTryout(
                            categoryId: controller.selectedKategoriId.value,
                          );

                          // controller.getBimbel(
                          //   menuCategoryId:
                          //       controller.selectedKategoriId.value?.toString(),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text("Cari"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
