import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Wishlist',
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(Icons.notifications_none, color: Colors.black, size: 28),
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
                    '0',
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
        child: Obx(() {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            hintText: 'Apa yang ingin Anda cari?',
                            suffixIcon: Icon(Icons.search, color: Colors.black),
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.teal),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.teal,
                                width: 2,
                              ),
                            ),
                          ),
                          onSubmitted: (value) {
                            // Jika user tekan "Enter" di keyboard
                            controller.getWhislist(search: value);
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Callback ketika tombol "Cari" ditekan
                          controller.getWhislist(
                            search: controller.searchController.text,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cari',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  Visibility(
                    visible: controller.whistlistData.isNotEmpty,
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(Routes.PAYMENT_WHISLIST);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Beli Semua',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            showBimbelBottomSheet(context);
                          },
                          child: Row(
                            children: [
                              Text(
                                'Filter',
                                style: TextStyle(
                                  color: Colors.teal,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: Colors.teal,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Loop manual pakai for
                  Skeletonizer(
                    enabled:
                        controller.whistlistData['data'] == null ||
                        controller.whistlistData['data'].isEmpty,
                    child: Column(
                      children:
                          (controller.whistlistData['data'] ?? List.filled(5, {})).map<
                            Widget
                          >((item) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child:
                                  controller.whistlistData['data'] == null ||
                                          controller
                                              .whistlistData['data']
                                              .isEmpty
                                      ? Row(
                                        children: [
                                          // Gambar skeleton
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Title skeleton
                                                Container(
                                                  width: double.infinity,
                                                  height: 16,
                                                  color: Colors.grey.shade300,
                                                ),
                                                SizedBox(height: 8),
                                                // Harga skeleton
                                                Container(
                                                  width: 100,
                                                  height: 14,
                                                  color: Colors.grey.shade300,
                                                ),
                                                SizedBox(height: 8),
                                                // Tag skeleton
                                                Container(
                                                  width: 60,
                                                  height: 14,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                      : _buildWishlistItem(
                                        imageUrl:
                                            item['productDetail']['gambar'],
                                        title:
                                            item['productDetail']['name'] ??
                                            item['productDetail']['formasi'],
                                        oldPrice:
                                            (item['productDetail']?['price_list']?['harga_terendah'] ??
                                                    "")
                                                .toString(),
                                        oldPriceFix:
                                            (item['productDetail']['price_list']?['harga_fix_terendah'] ??
                                                    "")
                                                .toString(),
                                        newPrice:
                                            (item['productDetail']?['price_list']?['harga_tertinggi'] ??
                                                    item['productDetail']['harga'])
                                                .toString(),
                                        newPriceFix:
                                            (item['productDetail']['price_list']?['harga_fix_tertinggi'] ??
                                                    item['productDetail']['harga_fix'])
                                                .toString(),
                                        tag:
                                            item['productDetail']['menu_category']['menu'],
                                        tagColor:
                                            item['productDetail']['menu_category']['warna']['hex'],
                                        isBimbel:
                                            item['bimbel_parent_id'] != null,
                                      ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildPagination()],
          ),
        ),
      ),
    );
  }

  Widget _buildWishlistItem({
    required String imageUrl,
    required String title,
    String? oldPrice,
    String? oldPriceFix,
    String? newPrice,
    String? newPriceFix,
    required bool isBimbel,
    required String tag,
    required String tagColor,
  }) {
    Color hexToColor(String hex) {
      hex = hex.replaceAll("#", ""); // buang # kalau ada
      if (hex.length == 6) {
        hex = "FF$hex"; // tambahin alpha (FF = 100% opacity)
      }
      return Color(int.parse(hex, radix: 16));
    }

    return Container(
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
              child: Image.network(imageUrl, fit: BoxFit.cover),
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
                    isBimbel == true
                        ? "${formatRupiah((oldPrice ?? ""))} - ${formatRupiah((newPrice ?? ""))}"
                        : "${formatRupiah((newPrice ?? ""))}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),

                  Text(
                    isBimbel == true
                        ? "${formatRupiah((oldPriceFix ?? ""))} - ${formatRupiah((newPriceFix ?? ""))}"
                        : "${formatRupiah((newPriceFix ?? ""))}",
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 3),
                  Align(
                    alignment: Alignment.centerRight, // Bikin rata kanan
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: hexToColor(tagColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
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
    );
  }

  void showBimbelBottomSheet(BuildContext context) {
    final controller = Get.put(WishlistController());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // biar ada radius
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 0.6, // maksimal 60% layar, bisa ubah sesuai kebutuhan
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: EdgeInsets.all(16),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Wishlist",
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

                  // Kategori
                  Text(
                    "Kategori",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
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
                                option['menu'],
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
                                    option['menu'];
                              },
                            );
                          }).toList(),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Produk
                  Text(
                    "Produk",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          controller.ProductOptions.map((option) {
                            final isSelected =
                                controller.selectedProductiId.value ==
                                option['id'];

                            return ChoiceChip(
                              label: Text(
                                option['menu'],
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
                                controller.selectedProductiId.value =
                                    option['id'];
                                controller.selectedEventProduct.value =
                                    option['menu'];
                              },
                            );
                          }).toList(),
                    ),
                  ),

                  Spacer(), // tombol di bawah
                  // Tombol Cari
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        controller.getWhislist(
                          menuCategoryId:
                              controller.selectedKategoriId.value?.toString(),
                          produk: controller.selectedEventProduct.value,
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
  }

  Widget _buildPagination() {
    final controller = Get.put(WishlistController());

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
}
