import 'dart:ffi' as ffi;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Image.asset(
          'assets/logo.png', // Dummy logo
          height: 55,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none, color: Colors.teal),
                onPressed: () {
                  Get.to(NotificationView());
                },
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '4',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: AppStyle.sreenPaddingHome,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bimbel Saya card (outline teal + light fill)
              InkWell(
                onTap: () {
                  Get.offNamed(Routes.MY_BIMBEL);
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: 'apa yang Anda cari',
                        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                        suffixIcon: Icon(Icons.search, color: Colors.black87),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      controller.getBimbel(
                        menuCategoryId:
                            controller.selectedKategoriId.value?.toString(),
                        search: controller.searchController.text,
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      'Cari',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 50),

              // Filter (right)
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
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
                if (controller.bimbelData.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'Belum ada paket tersedia',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.bimbelData.length,
                  itemBuilder: (context, index) {
                    final paket = controller.bimbelData[index];
                    // sesuaikan keys ('image','title','hargaFull','hargaDiskon','kategori') dengan datamu
                    return _cardPaketBimbel(
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
                        // controller.selectedUuid.value = paket['uuid'] ?? '';
                        Get.toNamed(
                          Routes.DETAIL_BIMBEL,
                          arguments: paket['uuid'],
                        ); // sesuaikan rute
                      },
                    );
                  },
                );
              }),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildPagination()],
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
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 140, // FIXED HEIGHT
        margin: EdgeInsets.only(bottom: 16),
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
            Container(
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(image, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
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
                      softWrap: true,
                    ),

                    SizedBox(height: 10),
                    Text(
                      "${formatRupiah(hargaTerendah)} - ${formatRupiah(hargaTertinggi)}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                    Text(
                      "${formatRupiah(hargaFixTerendah)} - ${formatRupiah(hargaFixTertinggi)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 3),
                    Align(
                      alignment: Alignment.centerRight, // Bikin rata kanan
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          kategori,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

Widget _buildPagination() {
  final controller = Get.put(BimbelController());

  return Obx(() {
    int current = controller.currentPage.value;
    int total = controller.totalPage.value;

    List<int> pagesToShow = [];
    pagesToShow.add(1);
    if (current - 1 > 1) pagesToShow.add(current - 1);
    if (current != 1 && current != total) pagesToShow.add(current);
    if (current + 1 < total) pagesToShow.add(current + 1);
    if (total > 1) pagesToShow.add(total);
    pagesToShow = pagesToShow.toSet().toList()..sort();

    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: current > 1 ? () => controller.goToPage(1) : null,
              icon: Icon(Icons.first_page),
              color: current > 1 ? Colors.teal : Colors.grey,
              iconSize: 28,
              padding: EdgeInsets.symmetric(horizontal: 4),
            ),
            IconButton(
              onPressed: current > 1 ? controller.prevPage : null,
              icon: Icon(Icons.chevron_left),
              color: current > 1 ? Colors.teal : Colors.grey,
              iconSize: 28,
              padding: EdgeInsets.symmetric(horizontal: 4),
            ),

            ...pagesToShow.map((page) {
              bool isActive = page == current;
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                child: GestureDetector(
                  onTap: () => controller.goToPage(page),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: isActive ? 14 : 10,
                      vertical: isActive ? 8 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.teal.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive ? Colors.teal : Colors.grey.shade300,
                        width: isActive ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      '$page',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.teal : Colors.black,
                        fontSize:
                            isActive
                                ? 16
                                : 14, // font lebih besar untuk page aktif
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),

            IconButton(
              onPressed: current < total ? controller.nextPage : null,
              icon: Icon(Icons.chevron_right),
              color: current < total ? Colors.teal : Colors.grey,
              iconSize: 28,
              padding: EdgeInsets.symmetric(horizontal: 4),
            ),
            IconButton(
              onPressed:
                  current < total ? () => controller.goToPage(total) : null,
              icon: Icon(Icons.last_page),
              color: current < total ? Colors.teal : Colors.grey,
              iconSize: 28,
              padding: EdgeInsets.symmetric(horizontal: 4),
            ),
          ],
        ),
      ),
    );
  });
}
