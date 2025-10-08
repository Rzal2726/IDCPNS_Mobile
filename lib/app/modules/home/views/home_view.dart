import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: controller.pages,
        ),
      ),

      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12.0,
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.tabIndex.value,
            onTap: (index) {
              controller.changeBottomBar(index);
              controller.currentIndex.value = index;
            },

            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/tryoutHomeIcon.svg',
                  color: Colors.grey,
                  width: 22,
                  height: 22,
                ),
                label: 'Tryout',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/bimbelHomeIcon.svg',
                  color: Colors.grey,
                  width: 22,
                  height: 22,
                ),
                label: 'Bimbel',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/platinumHomeIcon.svg',
                  color: Colors.grey,
                  width: 22,
                  height: 22,
                ),
                label: 'Platinum',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Obx(
      //   () => BottomNavigationBar(
      //     type: BottomNavigationBarType.fixed,
      //     selectedItemColor: Colors.teal,
      //     unselectedItemColor: Colors.grey,
      //     currentIndex: controller.currentIndex.value,
      //     onTap: controller.changePage,
      //     items: const [
      //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.assignment),
      //         label: 'Try Out',
      //       ),
      //       BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Bimbel'),
      //       BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Platinum'),
      //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildHelpContainer({
    required String title,
    required String description,
    required String buttonText,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[400], height: 1),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A085),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildServiceCard(
  IconData icon,
  String title,
  Color color, {
  String? badge,
}) {
  return Stack(
    children: [
      Container(
        width: 100,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(title, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      if (badge != null)
        Positioned(
          right: 4,
          top: 4,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badge,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
    ],
  );
}

Widget _buildCategoryItem(String title) {
  return Container(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // vertikal center
        crossAxisAlignment: CrossAxisAlignment.center, // horizontal center
        children: [
          Icon(Icons.apartment, size: 32, color: Colors.teal),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
