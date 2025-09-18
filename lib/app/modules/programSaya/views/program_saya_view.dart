import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/menuCategoryFilter.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import '../controllers/program_saya_controller.dart';

class ProgramSayaView extends GetView<ProgramSayaController> {
  const ProgramSayaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar(
        "Program Saya",
        onBack: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: Obx(() {
          // Pilih data sesuai tab
          final programList =
              controller.selectedTab.value == 0
                  ? controller.tryoutData
                  : controller.bimbelData;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Tabs
                  Row(
                    children: [
                      _buildTabItem('Tryout', 0),
                      SizedBox(width: 16),
                      _buildTabItem('Bimbel', 1),
                    ],
                  ),
                  Divider(thickness: 1, color: Colors.grey.withOpacity(0.2)),
                  SizedBox(height: 8),

                  // Search
                  TextField(
                    controller: controller.searchController,
                    onSubmitted:
                        (_) => controller.searchData(), // enter keyboard
                    decoration: InputDecoration(
                      hintText: 'Cari',
                      suffixIcon: GestureDetector(
                        onTap: () => controller.searchData(), // tap icon search
                        child: Icon(Icons.search, color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Title
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        showChoiceBottomSheet(
                          context: context,
                          title: "Jenis Tryout",
                          options: controller.options,
                          selectedValue: controller.selectedKategoriId,
                          onSelected: (id) {
                            final selectedOption = controller.options
                                .firstWhere((o) => o['id'] == id);
                            controller.selectedEventKategori.value =
                                selectedOption['name'];
                          },
                          onSubmit: () {
                            controller.selectedTab.value == 0
                                ? controller.getTryout(
                                  submenuCategoryId:
                                      controller.selectedKategoriId.value
                                          ?.toString(),
                                )
                                : controller.getBimbel(
                                  submenuCategoryId:
                                      controller.selectedKategoriId.value
                                          ?.toString(),
                                );
                          },
                        );
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

                  // Program List
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child:
                        programList.isEmpty
                            ? Text(
                              "Tidak ada program ditemukan",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                            : Column(
                              children: [
                                for (var program in programList)
                                  _buildProgramCard(
                                    controller.selectedTab.value == 0
                                        ? program['name']
                                        : program['bimbel_parent_name'],
                                    () {
                                      if (controller.selectedTab.value == 0) {
                                        Get.toNamed(
                                          Routes.DETAIL_TRYOUT_SAYA,
                                          arguments: program['uuid'],
                                        );
                                      } else {
                                        Get.toNamed(
                                          Routes.DETAIL_MY_BIMBEL,
                                          arguments: program['uuid'],
                                        );
                                      }
                                    },
                                  ),
                                SizedBox(height: 20),
                                Visibility(
                                  visible: programList.isNotEmpty,
                                  child: ReusablePagination(
                                    nextPage: controller.nextPage,
                                    prevPage: controller.prevPage,
                                    currentPage: controller.currentPage,
                                    totalPage: controller.totalPage,
                                    goToPage: controller.goToPage,
                                  ),
                                ),
                              ],
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

  Widget _buildTabItem(String title, int index) {
    return GestureDetector(
      onTap: () {
        controller.selectedTab.value = index;

        // Reset pagination
        controller.currentPage.value = 1;
        controller.totalPage.value = 1; // sementara, nanti diupdate dari API

        // Panggil fetch API sesuai tab
        if (index == 0) {
          controller.getTryout(page: 1); // mulai dari page 1
        } else if (index == 1) {
          controller.getBimbel(page: 1);
        }
      },

      child: Obx(() {
        bool isSelected = controller.selectedTab.value == index;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.teal : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            SizedBox(height: 4),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: 2,
              width: isSelected ? 40 : 0,
              color: Colors.teal,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProgramCard(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
