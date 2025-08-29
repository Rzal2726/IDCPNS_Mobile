import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pretest_ranking_controller.dart';

class PretestRankingView extends GetView<PretestRankingController> {
  const PretestRankingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Peringkat Pretest")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hasil Peringkat Pretest Bimbel",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              // Hasil peringkat
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  "Anda berada di peringkat 1 dari total 1 peserta",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              SizedBox(height: 16),

              // Search
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchCtrl,
                      decoration: InputDecoration(
                        hintText: "Cari Disini",
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
                              Get.snackbar(
                                "Cari",
                                "Mencari: ${controller.searchCtrl.text}",
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
                            child: const Text("Cari"),
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
                      controller.peserta.map((p) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal.shade50,
                              child: Text(
                                "${p['rank']}",
                                style: TextStyle(color: Colors.teal),
                              ),
                            ),
                            title: Text(
                              p['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                Text("Nilai "),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "${p['nilai']}",
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                );
              }),

              SizedBox(height: 12),

              // Pagination
              _buildPagination(),
            ],
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
