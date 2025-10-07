import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/emptyDataWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/paginationWidget.dart';
import 'package:idcpns_mobile/app/Components/widgets/searchWithButton.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/pretest_ranking_controller.dart';

class PretestRankingView extends GetView<PretestRankingController> {
  const PretestRankingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Peringkat Pretest", style: AppStyle.appBarTitle),
      ),
      body: SafeArea(
        child: Obx(() {
          return RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.teal,
            onRefresh: () => controller.getData(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: AppStyle.sreenPaddingHome,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Hasil Peringkat Pretest Bimbel",
                        style: AppStyle.style17Bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Hasil peringkat
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Text(
                        "Anda berada di peringkat ${controller.userRank.value} dari total ${controller.rankData.length} peserta",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    SizedBox(height: 18),

                    // Search
                    SearchRowButton(
                      controller: controller.searchController,
                      onSearch: () {
                        controller.getData(
                          search: controller.searchController.text,
                        );
                      },
                    ),

                    SizedBox(height: 16),

                    // List peserta
                    Obx(() {
                      final data = controller.rankData;

                      return controller.isLoading.value
                          // ✅ Masih loading → Skeleton
                          ? Skeletonizer(
                            enabled: true,
                            child: Column(
                              children: List.generate(3, (index) {
                                return Container(
                                  width: double.infinity,
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
                                );
                              }),
                            ),
                          )
                          : data.isEmpty
                          ? SizedBox(
                            height:
                                MediaQuery.of(context).size.height *
                                0.6, // biar vertikal tengah
                            child: Center(
                              child: EmptyStateWidget(
                                message:
                                    'Belum ada data rank tersedia saat ini',
                              ),
                            ),
                          )
                          // ✅ Ada data → List card
                          : Column(
                            children:
                                data.map((p) {
                                  return Card(
                                    color: Colors.white,
                                    margin: EdgeInsets.only(bottom: 8),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        16,
                                        12,
                                        16,
                                        14,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // badge rank
                                          Row(
                                            children: [
                                              Container(
                                                width: 26,
                                                height: 26,
                                                decoration: BoxDecoration(
                                                  color: Colors.lightBlue[400],
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "${p['rank']}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),

                                          // nama user
                                          Text(
                                            p['user_name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 10),

                                          // nilai
                                          Row(
                                            children: [
                                              Text(
                                                'Nilai',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.teal,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  "${p['total_point']}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          );
                    }),

                    SizedBox(height: 20),
                    if (controller.rankData.isNotEmpty)
                      ReusablePagination(
                        nextPage: controller.nextPage,
                        prevPage: controller.prevPage,
                        currentPage: controller.currentPage,
                        totalPage: controller.totalPage,
                        goToPage: controller.goToPage,
                      ),

                    // Paginat
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
