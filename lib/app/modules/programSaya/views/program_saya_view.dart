import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/emptyDataWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/menuCategoryFilter.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/searchWithButton.dart';
import 'package:idcpns_mobile/app/Components/widgets/skeletonizerWidget.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/program_saya_controller.dart';

class ProgramSayaView extends GetView<ProgramSayaController> {
  const ProgramSayaView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        Get.toNamed(Routes.HOME, arguments: {'initialIndex': 4});
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "Program Saya",
          onBack: () {
            Get.toNamed(Routes.HOME, arguments: {'initialIndex': 4});
          },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Custom Tabs
                  Obx(
                    () => Row(
                      children:
                          ["Tryout", "Bimbel"].asMap().entries.map((entry) {
                            final index = entry.key;
                            final option = entry.value;
                            final isSelected =
                                controller.selectedTab.value == index;

                            return GestureDetector(
                              onTap: () {
                                controller.selectedTab.value = index;

                                // Reset state
                                controller.currentPage.value = 1;
                                controller.totalPage.value = 0;
                                controller.searchController.clear();

                                // Panggil API sesuai tab
                                if (index == 0) {
                                  controller.getTryout();
                                } else {
                                  controller.getBimbel();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      option,
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
                                    SizedBox(height: 4),
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      height: 2,
                                      width: isSelected ? 20 : 0,
                                      color: Colors.teal,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  Divider(thickness: 1, color: Colors.grey.withOpacity(0.2)),
                  SizedBox(height: 8),

                  // Search
                  SearchRowButton(
                    controller: controller.searchController,
                    onSearch: () {
                      controller.searchData();
                    },
                  ),

                  SizedBox(height: 15),

                  // Filter
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
                                selectedOption['menu'];
                          },
                          onSubmit: () {
                            if (controller.selectedTab.value == 0) {
                              controller.getTryout(
                                submenuCategoryId:
                                    controller.selectedKategoriId.value
                                        .toString(),
                              );
                            } else {
                              controller.getBimbel(
                                submenuCategoryId:
                                    controller.selectedKategoriId.value
                                        .toString(),
                              );
                            }
                          },

                          onReset: () {
                            if (controller.selectedTab.value == 0) {
                              controller.getTryout(submenuCategoryId: "0");
                            } else {
                              controller.getBimbel(submenuCategoryId: "0");
                            }
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
                    child: Obx(() {
                      final programList =
                          controller.selectedTab.value == 0
                              ? controller.tryoutData
                              : controller.bimbelData;

                      if (programList.isNotEmpty) {
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: programList.length,
                              itemBuilder: (context, index) {
                                final program = programList[index];
                                return _buildProgramCard(
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
                                );
                              },
                            ),
                            programList.isNotEmpty
                                ? Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 8),
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
                                : SizedBox.shrink(),
                          ],
                        );
                      }

                      // kalau kosong, skeleton / empty state
                      return FutureBuilder(
                        future: Future.delayed(Duration(seconds: 5)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Skeletonizer(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 3,
                                itemBuilder:
                                    (context, index) => Container(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 80,
                                            color: Colors.grey.shade300,
                                          ),
                                          SizedBox(height: 7),
                                          Container(
                                            height: 16,
                                            width: 120,
                                            color: Colors.grey.shade300,
                                          ),
                                          SizedBox(height: 7),
                                          Container(
                                            height: 14,
                                            width: 160,
                                            color: Colors.grey.shade300,
                                          ),
                                        ],
                                      ),
                                    ),
                              ),
                            );
                          } else {
                            return Column(
                              children: [
                                EmptyStateWidget(
                                  message: "Tidak ada Program ditemukan",
                                ),
                                SizedBox(height: 30),
                              ],
                            );
                          }
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
