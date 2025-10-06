import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/detail_webinar_controller.dart';

class DetailWebinarView extends GetView<DetailWebinarController> {
  const DetailWebinarView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar("Detail Webinar"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Obx(() {
                  if (controller.loading.value == true) {
                    return Skeletonizer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset("assets/logo.png"),
                      ),
                    );
                  } else {
                    if (controller.dataWebinar.isEmpty) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset("assets/logo.png"),
                      );
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(controller.dataWebinar['gambar']),
                      );
                    }
                  }
                }),

                Obx(() {
                  if (controller.loading.value == true) {
                    return Skeletonizer(
                      child: Text(
                        "Judul Webinar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  } else {
                    if (controller.dataWebinar.isEmpty) {
                      return Text(
                        "Judul Webinar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      );
                    } else {
                      return Text(
                        controller.dataWebinar['nama'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      );
                    }
                  }
                }),
                Obx(() {
                  if (controller.loading.value == true) {
                    return Skeletonizer(
                      child: Text(
                        "Judul Webinar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  } else {
                    if (controller.dataWebinar.isEmpty) {
                      return Text(
                        "Tanggal Webinar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      );
                    } else {
                      return Text(
                        controller.tanggal[0],
                        style: TextStyle(fontSize: 16),
                      );
                    }
                  }
                }),
                Obx(() {
                  if (controller.loading.value == true) {
                    return Skeletonizer(
                      child: Text(
                        "Judul Webinar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  } else {
                    if (controller.dataWebinar.isEmpty) {
                      return Text(
                        "Jam Webinar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      );
                    } else {
                      return Row(
                        mainAxisSize:
                            MainAxisSize.min, // <-- biar pas konten aja
                        children: [
                          Icon(
                            Icons.hourglass_empty,
                            color: Colors.amber,
                            size: 20, // pastikan ukurannya sesuai
                          ),
                          const SizedBox(width: 4), // atur jarak manual
                          Text(
                            controller.tanggal[1],
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    }
                  }
                }),

                Row(
                  spacing: 16,
                  children: [
                    Obx(
                      () =>
                          controller.dataWebinar.isNotEmpty
                              ? Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final available = await canLaunchUrl(
                                      Uri.parse(
                                        controller.dataWebinar['link_zoom'],
                                      ),
                                    );
                                    if (controller.dataWebinar.isNotEmpty) {
                                      if (available) {
                                        launchUrl(
                                          Uri.parse(
                                            controller.dataWebinar['link_zoom'],
                                          ),
                                        );
                                      } else {
                                        Get.snackbar(
                                          "Gagal",
                                          "Webinar tidak tersedia",
                                          colorText: Colors.white,
                                          backgroundColor: Colors.pink,
                                        );
                                      }
                                    }
                                  },
                                  child: Text("Zoom"),
                                ),
                              )
                              : Skeletonizer(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text("data"),
                                ),
                              ),
                    ),
                    Obx(
                      () =>
                          controller.dataWebinar.isNotEmpty
                              ? Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final available = await canLaunchUrl(
                                      Uri.parse(
                                        controller.dataWebinar['link_youtube'],
                                      ),
                                    );
                                    if (controller.dataWebinar.isNotEmpty) {
                                      if (available) {
                                        launchUrl(
                                          Uri.parse(
                                            controller
                                                .dataWebinar['link_youtube'],
                                          ),
                                        );
                                      } else {
                                        Get.snackbar(
                                          "Gagal",
                                          "Webinar tidak tersedia",
                                          colorText: Colors.white,
                                          backgroundColor: Colors.pink,
                                        );
                                      }
                                    }
                                  },
                                  child: Text("Youtube"),
                                ),
                              )
                              : Skeletonizer(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text("data"),
                                ),
                              ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                  ),
                ),
                Obx(() {
                  if (controller.loading.value == true) {
                    return Skeletonizer(child: Text("data"));
                  } else {
                    return Container(
                      child: Html(
                        data: controller.dataWebinar['deskripsi_mobile'],
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
