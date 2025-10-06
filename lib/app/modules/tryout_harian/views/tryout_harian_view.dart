import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controllers/tryout_harian_controller.dart';

class TryoutHarianView extends GetView<TryoutHarianController> {
  const TryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar(
        "Tryout harian",
        onBack: () {
          Get.offAllNamed("/home", arguments: {"initialIndex": 3});
        },
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
              Obx(() {
                if (controller.loading.value == true) {
                  return Skeletonizer(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      title: Text(
                        "Kategori",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        // Aksi ketika kategori ditekan
                      },
                    ),
                  );
                }
                if (controller.categories.isEmpty) {
                  return Text("No Data");
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        final item = controller.categories[index];
                        final filteredData =
                            controller.doneList.where((data) {
                              return data['menu_category_id'] == item['id'];
                            }).toList();
                        final hasMengerjakan = filteredData.any(
                          (item) => item['sudah_mengerjakan_soal'] == 0,
                        );
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
                            leading: Icon(
                              Icons.circle,
                              color:
                                  hasMengerjakan
                                      ? Colors.pink
                                      : Colors.transparent,
                              size: 16,
                            ),
                            title: Text(
                              item['menu'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                            ),
                            onTap: () {
                              Get.toNamed(
                                "/kategori-tryout-harian",
                                arguments: item['uuid'],
                              );
                              // Aksi ketika kategori ditekan
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
