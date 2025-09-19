import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // false supaya tidak auto-pop
      onPopInvoked: (didPop) {
        if (!didPop) {
          // Saat tombol back ditekan
          Get.toNamed(Routes.HOME, arguments: {'initialIndex': 0});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "Wishlist",
          onBack: () {
            Get.toNamed(Routes.HOME, arguments: {'initialIndex': 0});
          },
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
                              suffixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
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
                    (controller.whistlistData['data'] != null &&
                            controller.whistlistData['data']!.isNotEmpty)
                        ? Row(
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
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
                        )
                        : Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/learningEmpty.svg",
                                height: 150,
                                width: 150,
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: Text(
                                  'Wishlist Anda saat ini kosong. Mulailah menambahkan produk favorit Anda sekarang!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                    SizedBox(height: 16),

                    // Loop manual pakai for
                    Column(
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
                    SizedBox(height: 20),
                    (controller.whistlistData['data'] != null &&
                            controller.whistlistData['data']!.isNotEmpty)
                        ? ReusablePagination(
                          nextPage: controller.nextPage,
                          prevPage: controller.prevPage,
                          currentPage: controller.currentPage,
                          totalPage: controller.totalPage,
                          goToPage: controller.goToPage,
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            );
          }),
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
}
