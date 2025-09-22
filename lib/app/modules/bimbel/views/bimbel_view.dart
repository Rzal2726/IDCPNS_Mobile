import 'dart:ffi' as ffi;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/emptyDataWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/searchWithButton.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/bimbel_controller.dart';

class BimbelView extends GetView<BimbelController> {
  BimbelView({super.key});
  final controller = Get.put(BimbelController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: basicAppBar(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: AppStyle.sreenPaddingHome,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bimbel Saya card (outline teal + light fill)
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.MY_BIMBEL);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    border: Border.all(color: Colors.teal.shade200, width: 1.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,

                            child: Center(
                              child: SvgPicture.asset(
                                "assets/computerIcon.svg",
                              ),
                            ),
                          ),
                          SizedBox(width: 13),
                          Text(
                            'Bimbel Saya',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 50),

              // Header Paket Bimbel
              Text('Paket Bimbel', style: AppStyle.style17Bold),
              SizedBox(height: 4),
              Text(
                'Belajar lebih intensif bersama mentor ahli di bidangnya.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              SizedBox(height: 20),

              // Search row
              SearchRowButton(
                controller: controller.searchController,
                onSearch: () {
                  controller.getBimbel(
                    menuCategoryId:
                        controller.selectedKategoriId.value?.toString(),
                    search: controller.searchController.text,
                  );
                },
                hintText: 'Apa yang ingin Anda cari?',
              ),

              SizedBox(height: 50),

              // Filter (right)
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    showBimbelBottomSheet(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Filter', style: TextStyle(color: Colors.teal)),
                      Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // List paket (mirip style gambar)
              Obx(() {
                if (controller.bimbelData.isNotEmpty) {
                  // ✅ Ada data
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.bimbelData.length,
                    itemBuilder: (context, index) {
                      final paket = controller.bimbelData[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: _cardPaketBimbel(
                          image: paket['gambar'] ?? '',
                          title: paket['name'] ?? '',
                          hargaFixTertinggi:
                              paket['price_list']['harga_fix_tertinggi'] ?? '',
                          hargaTertinggi:
                              paket['price_list']['harga_tertinggi'] ?? '',
                          hargaTerendah:
                              paket['price_list']['harga_terendah'] ?? '',
                          hargaFixTerendah:
                              paket['price_list']['harga_fix_terendah'] ?? '',
                          kategori: paket['menu_category']['menu'] ?? '',
                          color: Colors.teal,
                          onTap: () {
                            Get.toNamed(
                              Routes.DETAIL_BIMBEL,
                              arguments: paket['uuid'],
                            );
                          },
                        ),
                      );
                    },
                  );
                }

                // ⏳ Kalau kosong → skeleton dulu, baru empty message
                return FutureBuilder(
                  future: Future.delayed(Duration(seconds: 5)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      // Skeleton selama 5 detik
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder:
                            (context, index) => Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 100,
                                      color: Colors.grey.shade300,
                                    ),
                                    SizedBox(height: 7),
                                    Container(
                                      height: 16,
                                      width: 160,
                                      color: Colors.grey.shade300,
                                    ),
                                    SizedBox(height: 7),
                                    Container(
                                      height: 14,
                                      width: 120,
                                      color: Colors.grey.shade300,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      );
                    } else {
                      // ❌ Setelah 5 detik tetap kosong → pakai EmptyStateWidget
                      return EmptyStateWidget(
                        message: 'Belum ada paket yang tersedia',
                      );
                    }
                  },
                );
              }),
              controller.bimbelData.isNotEmpty
                  ? Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: ReusablePagination(
                        currentPage: controller.currentPage,
                        totalPage: controller.totalPage,
                        goToPage: controller.goToPage,
                        nextPage: controller.nextPage,
                        prevPage: controller.prevPage,
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  // ----- helper widget: paket card -----
  Widget _cardPaketBimbel({
    required String image,
    required String title,
    required int hargaTertinggi,
    required int hargaFixTertinggi,
    required int hargaTerendah,
    required int hargaFixTerendah,
    required String kategori,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140, // tetap fixed biar row-nya rapi
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// IMAGE SIDE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                image,
                height: 140,
                width: 140, // kasih lebar biar konsisten di row
                fit: BoxFit.contain, // jaga rasio, selalu kelihatan full
                errorBuilder:
                    (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${formatRupiah(hargaTerendah)} - ${formatRupiah(hargaTertinggi)}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${formatRupiah(hargaFixTerendah)} - ${formatRupiah(hargaFixTertinggi)}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            kategori,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
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
  }
}

void showBimbelBottomSheet(BuildContext context) {
  final controller = Get.put(BimbelController());

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
                                  controller.selectedKategoriId.value =
                                      option['id'];
                                  controller.selectedEventKategori.value =
                                      option['name'];
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
                          controller.getBimbel(
                            menuCategoryId:
                                controller.selectedKategoriId.value?.toString(),
                          );
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
