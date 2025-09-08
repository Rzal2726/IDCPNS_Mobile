import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

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
          return SingleChildScrollView(
            padding: AppStyle.screenPadding,
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            hintText: "Cari Disini",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.getData(
                                    search: controller.searchController.text,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text(
                                  "Cari",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // List peserta
                  Obx(() {
                    return Column(
                      children:
                          controller.rankData.map((p) {
                            return Card(
                              color: Colors.white,
                              margin: EdgeInsets.only(bottom: 8),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16, 12, 16, 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // badge kecil di atas (tidak overlay)
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

                                    // Nama
                                    Text(
                                      p['user_name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    // Baris Nilai
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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

                  SizedBox(height: 12),

                  // Paginat
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

  Widget _buildPagination() {
    return Obx(() {
      List<int> pagesToShow = [];
      int current = controller.currentPage.value;
      int total = controller.totalPages.value;

      pagesToShow.add(1);

      if (current > 2) {
        pagesToShow.add(current - 1);
      }

      if (current != 1 && current != total) {
        pagesToShow.add(current);
      }

      if (current < total - 1) {
        pagesToShow.add(current + 1);
      }

      if (total > 1) {
        pagesToShow.add(total);
      }

      pagesToShow = pagesToShow.toSet().toList()..sort();

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: controller.prevPage,
            child: Icon(
              Icons.chevron_left,
              color:
                  controller.currentPage.value > 1 ? Colors.teal : Colors.grey,
            ),
          ),
          SizedBox(width: 8),
          ...List.generate(pagesToShow.length, (index) {
            final page = pagesToShow[index];
            final isActive = page == controller.currentPage.value;
            bool addEllipsis = false;
            if (index < pagesToShow.length - 1) {
              if (pagesToShow[index + 1] - page > 1) {
                addEllipsis = true;
              }
            }
            return Row(
              children: [
                GestureDetector(
                  onTap: () => controller.goToPage(page),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.teal.shade50 : Colors.white,
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
                      ),
                    ),
                  ),
                ),
                if (addEllipsis)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("..."),
                  ),
              ],
            );
          }),
          SizedBox(width: 8),
          GestureDetector(
            onTap: controller.nextPage,
            child: Icon(
              Icons.chevron_right,
              color:
                  controller.currentPage.value < controller.totalPages.value
                      ? Colors.teal
                      : Colors.grey,
            ),
          ),
        ],
      );
    });
  }
}
