import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_svg/flutter_html_svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/detail_event_controller.dart';

class DetailEventView extends GetView<DetailEventController> {
  const DetailEventView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            backgroundColor: Colors.white,
            elevation: 1,
            scrolledUnderElevation: 0,
            title: Text("Detail Event"),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none, color: Colors.teal),
                    onPressed: () {
                      Get.to(NotificationView());
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
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  if (controller.loading.value == true) {
                    return Skeletonizer(child: Image.asset("assets/logo.png"));
                  } else {
                    if (controller.dataEvent.isEmpty) {
                      return Image.asset("assets/logo.png");
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(controller.dataEvent['gambar']),
                      );
                    }
                  }
                }),
                SizedBox(height: 16),
                Obx(() {
                  if (controller.loading.value == true) {
                    return Skeletonizer(child: Text("Judul"));
                  } else {
                    if (controller.dataEvent.isEmpty) {
                      return Text("Judul");
                    } else {
                      return Text(
                        controller.dataEvent['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      );
                    }
                  }
                }),
                SizedBox(height: 16),
                Obx(() {
                  if (controller.loading.value == true) {
                    return Skeletonizer(child: Text("Judul"));
                  } else {
                    if (controller.dataEvent.isEmpty) {
                      return Text("Judul");
                    } else {
                      return Row(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          Text(controller.dataEvent['review'].toString()),
                          Icon(Icons.circle, size: 8),
                          Icon(Icons.group, color: Colors.amber),

                          Text(
                            "${controller.dataEvent['jumlah_beli']} Sudah Bergabung",
                          ),
                        ],
                      );
                    }
                  }
                }),

                SizedBox(height: 16),

                Obx(() {
                  if (controller.loading.value) {
                    return Skeletonizer(
                      child: _buildRadioOption("Premmium", "0", "1", true),
                    );
                  } else {
                    if (controller.userData['level_name'] != "Platinum") {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jenis Paket",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          _buildRadioOption(
                            "Gratis ${controller.dataEvent["free_access"] ? "" : "(Sudah Berakhir)"}",
                            "0",
                            "Free",
                            controller.dataEvent["free_access"],
                          ),
                          _buildRadioOption(
                            "Premium",
                            controller.formatCurrency(
                              controller.dataEvent["harga_fix"].toString(),
                            ),
                            controller.dataEvent["uuid"],
                            true,
                          ),
                        ],
                      );
                    } else {
                      return SizedBox();
                    }
                  }
                }),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.selectedPaket.value == "") {
                        notifHelper.show(
                          "Mohon pilih paket terlebih dahulu",
                          type: 0,
                        );
                        return;
                      }
                      Get.toNamed(
                        "/tryout-event-payment",
                        arguments: controller.uuid,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade300,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text("Daftar Sekarang"),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Ingin mendapatkan setiap event tryout premium secara gratis?",
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed("/upgrade-akun");
                  },
                  child: Text(
                    "Upgrade ke platinum sekarang!",
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:
                        controller.option.map((option) {
                          final isSelected =
                              controller.selectedOption.value == option;
                          return GestureDetector(
                            onTap:
                                () => controller.selectedOption.value = option,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    option,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.teal
                                              : Colors.grey[700],
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    height: 2,
                                    width: isSelected ? 20 : 0,
                                    color: Colors.teal,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  );
                }),
                Obx(() {
                  final option = controller.selectedOption.value;

                  if (controller.loading == true) {
                    return Skeletonizer(child: Text("data"));
                  }

                  switch (option) {
                    case "FAQ":
                      return Container(
                        margin: const EdgeInsets.all(16),
                        child:
                            controller.dataEvent.isEmpty
                                ? const Center(child: Text("Tidak ada FAQ"))
                                : _htmlCard(controller.dataEvent['faq_mobile']),
                      );
                    default: // Detail
                      return Container(
                        margin: const EdgeInsets.all(16),
                        child:
                            controller.dataEvent.isEmpty
                                ? const Skeletonizer(
                                  enabled: true,
                                  child: Text(
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer vel velit in nisi pulvinar ornare. Integer faucibus mauris nec mauris aliquet, eget molestie tortor auctor. Phasellus sit amet congue purus. Curabitur cursus mauris quis sapien aliquet rhoncus. Donec semper nibh mollis orci posuere pulvinar. Vestibulum suscipit eu massa elementum efficitur",
                                  ),
                                )
                                : _htmlCard(
                                  controller.dataEvent['deskripsi_mobile'],
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

  Widget _buildRadioOption(
    String title,
    String price,
    String uuid, // ganti tipe ke String
    bool isDisabled,
  ) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kiri: Radio + Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio<String>(
                value: uuid, // ✅ sekarang valuenya ID, bukan title
                groupValue: controller.selectedPaket.value,
                onChanged:
                    !isDisabled
                        ? null
                        : (value) {
                          if (value != null) {
                            controller.selectedPaket.value =
                                value; // yang kepilih sekarang UUID
                          }
                        },
                activeColor: Colors.teal,
              ),
              Text(
                title, // 👈 yang dilihat user tetap title
                style: TextStyle(
                  fontSize: 14,
                  color: !isDisabled ? Colors.grey : Colors.black,
                ), // opsional, biar rapi
              ),
            ],
          ),

          // Kanan: Harga lama + baru
          Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: !isDisabled ? Colors.grey : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _htmlCard(String isi) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Html(
        data: isi.replaceAll(
          "!#RangeDateTryout",
          controller.formatDate(
            controller.dataEvent['startdate'].toString(),
            controller.dataEvent['enddate'].toString(),
          ),
        ),
        style: {
          ".mt-3": Style(margin: Margins.only(top: 12)),
          ".p-4": Style(padding: HtmlPaddings.all(16)),
          ".border": Style(border: Border.all(color: Colors.grey.shade300)),
          ".text-lg": Style(fontSize: FontSize(18)),
          ".font-bold": Style(fontWeight: FontWeight.bold),
          ".text-muted-700": Style(color: Colors.grey.shade700),
          "svg": Style(width: Width(24), verticalAlign: VerticalAlign.middle),
        },
        extensions: [SvgHtmlExtension()],
      ),
    );
  }
}
