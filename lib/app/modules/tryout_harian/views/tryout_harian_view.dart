import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/tryout_harian_controller.dart';

class TryoutHarianView extends GetView<TryoutHarianController> {
  const TryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.offAllNamed("/home", arguments: {"initialIndex": 3});
              },
              icon: Icon(Icons.arrow_back),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text("Tryout Harian"),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_rounded, color: Colors.teal),
                    onPressed: () {
                      // ✅ Best practice: use a function for navigation
                      Get.to(() => NotificationView());
                    },
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '4',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kalender
              TableCalendar(
                rowHeight: 40,
                headerStyle: const HeaderStyle(
                  leftChevronVisible: false, // <<< Hilangkan tombol kiri
                  rightChevronVisible: false,
                  formatButtonVisible: false,
                  titleCentered: false,
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                calendarFormat: CalendarFormat.week,
                availableGestures: AvailableGestures.none,
                selectedDayPredicate: (day) => isSameDay(day, controller.today),
                focusedDay: controller.today,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Daftar kategori
              Expanded(
                child: ListView.builder(
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final item = controller.categories[index];
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading:
                            item['showDot']
                                ? const Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: Colors.red,
                                )
                                : const SizedBox(width: 12),
                        title: Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          Get.toNamed("/kategori-tryout-harian");
                          // Aksi ketika kategori ditekan
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
