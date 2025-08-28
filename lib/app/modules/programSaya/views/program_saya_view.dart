import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildTabItem('Tryout', 0),
                SizedBox(width: 16),
                _buildTabItem('Bimbel', 1),
              ],
            ),
            Divider(thickness: 1, color: Colors.grey.withOpacity(0.2)),
            SizedBox(height: 8),
            TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                hintText: 'Cari',
                suffixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF009379)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF009379)),
                ),
                isDense: true,
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Program Saya',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            SizedBox(height: 12),
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
              child: Column(
                children: [
                  _buildProgramCard('TRYOUT SKD CPNS 2025\nBATCH 60'),
                  Divider(color: Colors.grey[200]),
                  _buildPagination(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Obx(() {
        bool isSelected = controller.selectedTab.value == index;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.teal : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            if (isSelected)
              Container(height: 2, width: 40, color: Colors.teal)
            else
              SizedBox(height: 2),
          ],
        );
      }),
    );
  }

  Widget _buildProgramCard(String title) {
    return Container(
      padding: EdgeInsets.all(16),
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
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final controller = Get.put(ProgramSayaController());
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: controller.prevPage,
            child: Icon(
              Icons.chevron_left,
              color:
                  controller.currentPage.value > 1 ? Colors.teal : Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
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
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text("..."),
                  ),
              ],
            );
          }),
          const SizedBox(width: 8),
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
