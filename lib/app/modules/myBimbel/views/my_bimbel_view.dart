import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/my_bimbel_controller.dart';

class MyBimbelView extends GetView<MyBimbelController> {
  const MyBimbelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: Text('Bimbel Saya', style: TextStyle(color: Colors.black)),
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
      ),
      body: SafeArea(
        child: Obx(() {
          return Padding(
            padding: AppStyle.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & subtitle
                Text(
                  'Bimbel Saya',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Pilih bimbel dan belajar bersama peserta lainnya.',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 16),

                // Search bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari',
                          suffixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.teal),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 8,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        controller.getData(
                          menuCategoryId:
                              controller.selectedKategoriId.value?.toString(),
                          search: controller.searchController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Cari',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Filter button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => showBimbelBottomSheet(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Filter',
                          style: TextStyle(color: Colors.teal, fontSize: 16),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),

                // List Bimbel + Skeletonizer
                controller.isLoading.value
                    ? Skeletonizer(
                      enabled: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 5, // jumlah skeleton item
                        itemBuilder:
                            (context, index) => Container(
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 12,
                                    width: 60,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(height: 7),
                                  Container(
                                    height: 16,
                                    width: double.infinity,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(height: 7),
                                  Container(
                                    height: 14,
                                    width: double.infinity,
                                    color: Colors.grey.shade300,
                                  ),
                                ],
                              ),
                            ),
                      ),
                    )
                    : controller.listBimbel['data'].isEmpty
                    ? Center(child: Text('Data kosong'))
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.listBimbel['data'].length,
                      itemBuilder: (context, index) {
                        var item = controller.listBimbel['data'][index];
                        return InkWell(
                          onTap:
                              () => Get.toNamed(
                                Routes.DETAIL_MY_BIMBEL,
                                arguments: item['uuid'],
                              ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(
                                      int.parse(
                                        item['hex'].toString().replaceFirst(
                                          '#',
                                          '0xff',
                                        ),
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item['menu']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  item['bimbel_parent_name']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 7),
                                Text(
                                  item['bimbel_name']!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                SizedBox(height: 20), // jarak sebelum pagination
                // Pagination
                if (controller.listBimbel['data'] != null &&
                    controller.listBimbel['data'].isNotEmpty)
                  Center(
                    child: ReusablePagination(
                      currentPage: controller.currentPage,
                      totalPage: controller.totalPage,
                      goToPage: controller.goToPage,
                      nextPage: controller.nextPage,
                      prevPage: controller.prevPage,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

void openFilter() {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: Text('Terapkan'),
          ),
        ],
      ),
    ),
  );
}

void showBimbelBottomSheet(BuildContext context) {
  final controller = Get.put(MyBimbelController());

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
                          controller.getData(
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
