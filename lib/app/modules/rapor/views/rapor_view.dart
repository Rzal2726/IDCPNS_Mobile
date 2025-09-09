import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/rapor_controller.dart';

class RaporView extends GetView<RaporController> {
  const RaporView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("Rapor"),
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
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white, // background lembut
        child: Card(
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Tryout
                Obx(
                  () =>
                      controller.tryoutSaya.isEmpty
                          ? Skeletonizer(
                            child: Container(
                              height: 20,
                              width: 180,
                              color: Colors.grey.shade300,
                            ),
                          )
                          : Center(
                            child: Text(
                              controller.tryoutSaya['tryout']['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Rapor",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Obx(() {
                      return controller.statistics.isNotEmpty
                          ? SizedBox(
                            width: 160, // fix biar nggak error flex
                            child: DropdownButton<String>(
                              value:
                                  controller
                                              .selectedStatistic
                                              .value
                                              .isNotEmpty &&
                                          controller.statisticLabels.contains(
                                            controller.selectedStatistic.value,
                                          )
                                      ? controller.selectedStatistic.value
                                      : null,
                              hint: const Text("Filter"),
                              isExpanded: true,
                              underline: const SizedBox(),
                              borderRadius: BorderRadius.circular(12),
                              dropdownColor: Colors.white,
                              items:
                                  controller.statisticLabels.map((label) {
                                    return DropdownMenuItem<String>(
                                      value: label,
                                      child: Text(label),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                controller.selectedStatistic.value =
                                    value ?? '';
                              },
                            ),
                          )
                          : Skeletonizer(
                            child: Container(
                              height: 20,
                              width: 100,
                              color: Colors.grey.shade300,
                            ),
                          );
                    }),
                  ],
                ),

                const SizedBox(height: 20),

                // Chart
                SizedBox(
                  height: 250,
                  child: Obx(() {
                    if (controller.nilaiChart.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SfCartesianChart(
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                      ),
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(),
                      series: controller.buildSeries(controller.statistics),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
