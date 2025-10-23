import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/Card/jadwalPertemuanCard.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../controllers/detail_bimbel_controller.dart';

class DetailBimbelView extends GetView<DetailBimbelController> {
  const DetailBimbelView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // false supaya tidak auto-pop
      onPopInvoked: (didPop) {
        if (!didPop) {
          // Saat tombol back ditekan
          // Get.offAllNamed(Routes.HOME, arguments: {'initialIndex': 2});
          Get.back();
          // (Get.find<HomeController>()).currentIndex.value = 4;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "Detail Bimbel",
          onBack: () {
            // Get.offAllNamed(Routes.HOME, arguments: {'initialIndex': 2});
            Get.back();
          },
        ),
        body: SafeArea(
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.teal,
            onRefresh: () async {
              return await controller.refresh();
            },
            child: Obx(() {
              var data = controller.datalBimbelData;

              // Kalau data kosong, tampilkan skeleton
              if (data.isEmpty) {
                return SingleChildScrollView(
                  padding: AppStyle.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner
                      Skeletonizer(
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Judul
                      Skeletonizer(
                        child: Container(
                          height: 30,
                          width: 200,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Rating & Peserta
                      Row(
                        children: [
                          Skeletonizer(
                            child: Container(
                              height: 16,
                              width: 50,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          SizedBox(width: 8),
                          Skeletonizer(
                            child: Container(
                              height: 16,
                              width: 150,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),

                      // Jenis Paket
                      Skeletonizer(
                        child: Container(
                          height: 16,
                          width: 120,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      SizedBox(height: 12),

                      // List paket
                      Column(
                        children: List.generate(3, (index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Skeletonizer(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 16),

                      // Tombol Wishlist
                      Skeletonizer(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                      // Tombol Daftar
                      Skeletonizer(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // TabBar
                      Skeletonizer(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),

                      // Konten tab
                      Skeletonizer(
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Kalau data sudah ada, tampilkan konten sebenarnya
              return SingleChildScrollView(
                padding: AppStyle.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '${data['gambar']}',
                        width: double.infinity, // lebar tetap full
                        fit: BoxFit.cover, // ini bisa diubah sesuai kebutuhan
                      ),
                    ),

                    SizedBox(height: 16),

                    // Judul
                    Text(
                      '${data['name']}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),

                    // Rating dan peserta
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${data['review']}',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.people, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${data['jumlah_dibeli']} Peserta Telah Bergabung',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),

                    // Jenis Paket
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!(data['bimbel'].any(
                          (b) => b['is_showing'] == true,
                        ))) ...[
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity, // Lebar penuh
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed(
                                  Routes.MY_BIMBEL,
                                ); // arah ke halaman Bimbel user
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.teal.shade300,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Bimbel Saya',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          SizedBox(height: 25),
                          Text(
                            'Jenis Paket',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children: [
                              for (int i = 0; i < data['bimbel'].length; i++)
                                Obx(() {
                                  var subData = data['bimbel'][i];

                                  // skip paket yang tidak sedang ditampilkan
                                  if (!(subData['is_showing'] ?? false))
                                    return SizedBox.shrink();

                                  // skip paket yang sudah dibeli
                                  if (subData['is_purchase'] == true)
                                    return SizedBox.shrink();

                                  // hitung harga tampil
                                  var hargaTampil = controller
                                      .hitungHargaTampil(
                                        subData,
                                        i,
                                        data['bimbel'],
                                      );

                                  return _buildRadioOption(
                                    subData['name'], // title
                                    formatRupiah(
                                      subData['harga'],
                                    ), // harga lama
                                    hargaTampil.toString(), // harga baru
                                    subData['uuid'], // value radio
                                    controller, // controller
                                    isDisabled:
                                        false, // karena sudah disaring yang dibeli
                                  );
                                }),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              // Tombol Wishlist
                              Expanded(
                                child: OutlinedButton(
                                  onPressed:
                                      controller.isLoadingButton.value
                                          ? null
                                          : () {
                                            if (controller.isCheklist == true) {
                                              controller.getDeleteWhisList();
                                            } else {
                                              controller.getAddWhislist();
                                            }
                                          },
                                  style: OutlinedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.teal.shade300,
                                    side: BorderSide(
                                      color: Colors.teal.shade300,
                                      width: 1.5,
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child:
                                      controller.isLoadingButton.value
                                          ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.teal.shade300,
                                                  ),
                                            ),
                                          )
                                          : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                controller.isCheklist == true
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color:
                                                    controller.isCheklist ==
                                                            true
                                                        ? Colors.teal
                                                        : Colors.teal.shade300,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                controller.isCheklist == true
                                                    ? 'Hapus Wishlist'
                                                    : 'Tambah Wishlist',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.teal.shade300,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Tombol Daftar
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (controller.selectedPaket.value == "") {
                                      notifHelper.show(
                                        "Silakan pilih paket terlebih dahulu.",
                                        type: 0,
                                      );
                                      return;
                                    }
                                    controller.getData();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.teal.shade300,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Daftar',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 16),
                    // TabBar
                    Column(
                      children: [
                        // Custom Tab
                        Row(
                          children: List.generate(controller.tabs.length, (
                            index,
                          ) {
                            final title = controller.tabs[index];
                            return Expanded(
                              // <-- ini bikin tiap tab sama lebar
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap:
                                      () =>
                                          controller.currentIndex.value = index,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ), // cukup vertikal
                                    child: Obx(() {
                                      final isSelected =
                                          controller.currentIndex.value ==
                                          index;
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            title,
                                            textAlign:
                                                TextAlign
                                                    .center, // teks di tengah tab
                                            style: TextStyle(
                                              color:
                                                  isSelected
                                                      ? Colors.teal
                                                      : Colors.black54,
                                              fontWeight:
                                                  isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 200,
                                            ),
                                            height: 2,
                                            width:
                                                isSelected
                                                    ? 40
                                                    : 0, // indikator tetap kecil
                                            color: Colors.teal,
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),

                        SizedBox(height: 12),

                        // Konten Tab
                        Obx(() {
                          final currentIndex = controller.currentIndex.value;

                          Widget currentChild;
                          switch (currentIndex) {
                            case 0:
                              currentChild = Html(
                                data: data['deskripsi_mobile'],
                              );
                              break;
                            case 1:
                              currentChild = SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    ...controller.getPaginatedData().map((
                                      item,
                                    ) {
                                      return pertemuanCardBuilder(
                                        hari: item["hari"] ?? "",
                                        tanggal: item["tanggal"] ?? "",
                                        jam: item["jam"] ?? "",
                                        regulerTitle: item["regulerTitle"],
                                        regulerDesc: item["regulerDesc"],
                                        extendedTitle: item["extendedTitle"],
                                        extendedDesc: item["extendedDesc"],
                                        extendedPlatinumTitle:
                                            item["extendedPlatinumTitle"],
                                        extendedPlatinumDesc:
                                            item["extendedPlatinumDesc"],
                                      );
                                    }).toList(),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Center(
                                        child: ReusablePagination(
                                          currentPage: controller.currentPage,
                                          totalPage: controller.totalPage,
                                          goToPage: controller.goToPage,
                                          prevPage: controller.prevPage,
                                          nextPage: controller.nextPage,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              break;
                            case 2:
                              currentChild = Html(data: data['faq_mobile']);
                              break;
                            default:
                              currentChild = SizedBox();
                          }

                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: currentChild,
                          );
                        }),
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

  Widget _buildRadioOption(
    String title,
    String oldPrice,
    String newPrice,
    String uuid,
    DetailBimbelController controller, {
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
