import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/kategori_tryout_harian_controller.dart';

class KategoriTryoutHarianView extends GetView<KategoriTryoutHarianController> {
  const KategoriTryoutHarianView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // <- biar kita kontrol manual
      onPopInvoked: (didPop) {
        if (!didPop) {
          Get.offAllNamed("/tryout-harian");
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Obx(
            () =>
                controller.categories.isNotEmpty
                    ? secondaryAppBar(
                      "Kategori ${controller.categories.where((f) => f['uuid'] == controller.CategoryUuid).first['menu']}",
                    )
                    : Skeletonizer(child: secondaryAppBar("Kategori asdssa")),
          ),
        ),

        body: SafeArea(
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.teal,
            onRefresh: () => controller.initTryout(),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: const Color.fromARGB(255, 255, 255, 220),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.amber),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                textAlign: TextAlign.center,
                                "Untuk melihat peringkat anda silahkan kerjakan tryout terlebih dahulu",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.teal),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                ),
                                onPressed: () {
                                  Get.toNamed(
                                    "/peringkat-tryout-harian",
                                    arguments: controller.CategoryUuid,
                                  );
                                },
                                child: const Text(
                                  "Lihat Peringkat Keseluruhan",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      textAlign: TextAlign.start,
                      "Kamis, 4 September",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(() {
                      if (controller.loading.value == true) {
                        return Skeletonizer(
                          child: _dataCard(
                            category: "Kategori",
                            judul: "Jusul",
                            categoryColor: Colors.teal,
                          ),
                        );
                      } else {
                        if (controller.tryoutList.isEmpty) {
                          return Center(
                            child: Column(
                              spacing: 16,
                              children: [
                                SizedBox(height: 64),
                                SvgPicture.asset(
                                  "assets/learningEmpty.svg",
                                  width: 240,
                                ),
                                Text("Tidak Ada Tryout"),
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: controller.tryoutList.length,
                            itemBuilder: (context, index) {
                              final data = controller.tryoutList[index];
                              return _dataCard(
                                category: data['menu_category']['menu'],
                                judul: data['nama'],
                                categoryColor: Colors.teal,
                                uuid: data['uuid'],
                                isDone: data['sudah_mengerjakan_soal'] == 1,
                              );
                            },
                          );
                        }
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataCard({
    required String category,
    required String judul,
    required Color categoryColor,
    uuid = "",
    isDone = false,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: _badge(
                title: category,
                foregroundColor: Colors.white,
                backgroundColor: categoryColor,
              ),
            ),
            Text(
              judul,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDone ? Colors.teal : Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      if (isDone) {
                        Get.toNamed(
                          '/pembahasan-tryout-harian',
                          arguments: uuid,
                        );
                      }
                    },
                    child: const Text(
                      "Pembahasan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDone ? Colors.grey : Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      if (!isDone) {
                        Get.toNamed("/detail-tryout-harian", arguments: uuid);
                      }
                    },
                    child: const Text(
                      "Kerjakan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge({
    required String title,
    required Color foregroundColor,
    required Color backgroundColor,
  }) {
    return Card(
      color: backgroundColor,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Center(
          child: Text(title, style: TextStyle(color: foregroundColor)),
        ),
      ),
    );
  }
}
