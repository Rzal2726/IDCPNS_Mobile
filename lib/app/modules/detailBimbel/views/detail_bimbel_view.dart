import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/Card/jadwalPertemuanCard.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/detail_bimbel_controller.dart';

class DetailBimbelView extends GetView<DetailBimbelController> {
  const DetailBimbelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: secondaryAppBar("Detail Bimbel"),
      ),
      body: SafeArea(
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
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),

                // Judul
                Text(
                  '${data['name']}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                SizedBox(height: 25),

                // Jenis Paket
                Text(
                  'Jenis Paket',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    for (int i = 0; i < data['bimbel'].length; i++)
                      Obx(() {
                        final subData = data['bimbel'][i];

                        // filter paket yang sedang ditampilkan
                        if (!(subData['is_showing'] ?? false)) {
                          return SizedBox.shrink();
                        }

                        // index paket pertama yang sudah dibeli
                        final firstPurchasedIndex = data['bimbel'].indexWhere(
                          (e) => e['is_purchase'] == true,
                        );

                        // skip paket yang lebih murah dari paket yang sudah dibeli
                        if (firstPurchasedIndex != -1 &&
                            i < firstPurchasedIndex) {
                          return SizedBox.shrink();
                        }

                        // harga yang ditampilkan dikurangi harga paket yang sudah dibeli
                        final hargaTampil =
                            (firstPurchasedIndex != -1 &&
                                    i > firstPurchasedIndex)
                                ? subData['harga_fix'] -
                                    data['bimbel'][firstPurchasedIndex]['harga_fix']
                                : subData['harga_fix'];

                        // disable jika paket sudah dibeli
                        final isDisabled =
                            (firstPurchasedIndex != -1 &&
                                i == firstPurchasedIndex);

                        return _buildRadioOption(
                          subData['name'], // title
                          formatRupiah(subData['harga']), // harga lama
                          formatRupiah(hargaTampil), // harga baru
                          subData['uuid'], // value radio
                          controller, // controller
                          isDisabled: isDisabled, // disable jika sudah dibeli
                        );
                      }),
                  ],
                ),

                SizedBox(height: 16),

                // Tombol Wishlist
                OutlinedButton.icon(
                  icon: Icon(
                    controller.datalCheckList.isNotEmpty
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        controller.datalCheckList.isNotEmpty
                            ? Colors.white
                            : Colors.teal,
                  ),
                  label: Text(
                    controller.datalCheckList.isNotEmpty
                        ? 'Hapus dari Wishlist -'
                        : 'Tambahkan ke Wishlist +',
                    style: TextStyle(
                      color:
                          controller.datalCheckList.isNotEmpty
                              ? Colors.white
                              : Colors.teal,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        controller.datalCheckList.isNotEmpty
                            ? Colors.teal
                            : Colors.white,
                    side: BorderSide(color: Colors.teal, width: 2),
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (controller.datalCheckList.isNotEmpty) {
                      controller.getDeleteWhisList();
                    } else {
                      controller.getAddWhislist();
                    }
                  },
                ),
                SizedBox(height: 8),

                // Tombol Daftar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (controller.selectedPaket.value == "") {
                      Get.snackbar(
                        "Peringatan",
                        "Silakan pilih paket terlebih dahulu.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.withOpacity(0.8),
                        colorText: Colors.white,
                      );
                      return;
                    }
                    Get.toNamed(
                      Routes.PAYMENT_DETAIL,
                      arguments: controller.selectedPaket.value,
                    );
                  },
                  child: Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // TabBar
                Column(
                  children: [
                    // Custom Tab
                    Row(
                      children: List.generate(controller.tabs.length, (index) {
                        final title = controller.tabs[index];
                        return Expanded(
                          // <-- ini bikin tiap tab sama lebar
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap:
                                  () => controller.currentIndex.value = index,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ), // cukup vertikal
                                child: Obx(() {
                                  final isSelected =
                                      controller.currentIndex.value == index;
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
                                        duration: Duration(milliseconds: 200),
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
                    IndexedStack(
                      index: controller.currentIndex.value,
                      children: [
                        // Case 0
                        SizedBox(
                          height:
                              MediaQuery.of(
                                context,
                              ).size.height, // batas tinggi = layar penuh
                          child: SingleChildScrollView(
                            child: Html(data: data['deskripsi_pc']),
                          ),
                        ),

                        // Case 1
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              // List + pagination jadi satu scroll
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      controller.getPaginatedData().length +
                                      1, // +1 buat pagination
                                  itemBuilder: (context, index) {
                                    if (index <
                                        controller.getPaginatedData().length) {
                                      final item =
                                          controller.getPaginatedData()[index];
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
                                    } else {
                                      // item terakhir = pagination
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: ReusablePagination(
                                          currentPage: controller.currentPage,
                                          totalPage: controller.totalPage,
                                          goToPage: controller.goToPage,
                                          prevPage: controller.prevPage,
                                          nextPage: controller.nextPage,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Case 2
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: SingleChildScrollView(
                            child: Html(data: data['faq_pc']),
                          ),
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

  Widget _buildRadioOption(
    String title,
    String oldPrice,
    String newPrice,
    String uuid,
    DetailBimbelController controller, {
    bool isDisabled = false, // disable radio kalau paket sudah dibeli
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kiri: Radio + Title
          Row(
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
                              print("xxx selected: ${value.toString()}");
                            }
                          },
                  activeColor: Colors.teal,
                ),
              ),
              Text(title, style: TextStyle(fontSize: 14)),
            ],
          ),

          // Kanan: Harga lama + baru
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                oldPrice,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              Text(
                isDisabled ? '' : newPrice, // kalau disabled, harga baru hilang
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
