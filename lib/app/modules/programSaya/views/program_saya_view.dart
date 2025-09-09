import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import '../controllers/program_saya_controller.dart';

class ProgramSayaView extends GetView<ProgramSayaController> {
  const ProgramSayaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Program Saya',
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
                    '9+',
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
                  SizedBox(height: 16),

                  // Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Program Saya',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Program List
                  Container(
                    padding: EdgeInsets.all(16),
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
                              ],
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
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
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
          GestureDetector(
            onTap: onTap, // langsung pakai callback
            child: Container(
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
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final controller = Get.put(ProgramSayaController());

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
