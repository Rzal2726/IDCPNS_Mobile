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
            fontSize: 18,
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
            // Obx(
            //   () => Row(
            //     children: [
            //       _buildTabItem('Tryout', 0),
            //       SizedBox(width: 16),
            //       _buildTabItem('Bimbel', 1),
            //     ],
            //   ),
            // ),
            Divider(thickness: 1, color: Colors.grey.withOpacity(0.2)),
            SizedBox(height: 8),
            TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                hintText: 'Cari',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
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
            _buildProgramCard('TRYOUT SKD CPNS 2025\nBATCH 60'),
            SizedBox(height: 16),
            _buildPagination(),
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
                color: isSelected ? Color(0xFF009379) : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            if (isSelected)
              Container(height: 2, width: 40, color: Color(0xFF009379))
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
          Icon(Icons.arrow_forward_ios, color: Color(0xFF009379), size: 18),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.chevron_left, color: Colors.grey),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.4)),
          ),
          child: Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 8),
        Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }
}
