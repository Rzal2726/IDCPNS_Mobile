import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';

import '../controllers/detail_tryout_saya_controller.dart';
import '../models/chart_data_model.dart';
import 'package:intl/intl.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

class DetailTryoutSayaView extends GetView<DetailTryoutSayaController> {
  // ❌ REMOVED: Never put a controller inside the build method or as a view property.
  // final controller = Get.put(DetailTryoutSayaController());

  DetailTryoutSayaView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // biar kita yang kontrol back nya
      onPopInvoked: (didPop) {
        if (!didPop) {
          Get.offAllNamed('/tryout-saya');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(400),
          child: secondaryAppBar(
            "Detail Tryout Saya",
            onBack: () => Get.offAllNamed('/tryout-saya'),
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: () => controller.initTryoutSaya(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppStyle.sreenPaddingHome,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 1,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Obx(
                        () => Column(
                          // spacing: 8, // ❌ REMOVED: This property does not exist
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                _badge(
                                  isi:
                                      controller.tryOutSaya['ispremium'] == 1
                                          ? "Premium"
                                          : "Gratis",
                                  backgroundColor:
                                      controller.tryOutSaya['ispremium'] == 1
                                          ? Colors.amber
                                          : Colors.lightBlue,
                                ),
                                controller.tryOutSaya['isdone'] == 1
                                    ? _badge(
                                      isi:
                                          controller.tryOutSaya['islulus'] == 1
                                              ? "Lulus"
                                              : "Tidak Lulus",
                                      backgroundColor:
                                          controller.tryOutSaya['islulus'] == 1
                                              ? Colors.green
                                              : Colors.pink,
                                    )
                                    : _badge(
                                      isi: "Belum Dikerjakan",
                                      backgroundColor: Colors.grey,
                                    ),
                              ],
                            ),
                            SizedBox(height: 12), // ✅ ADDED: Spacing
                            controller.tryOutSaya.isEmpty
                                ? Skeletonizer(
                                  child: Text(
                                    "Judul Tryout",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                                : Text(
                                  controller.tryOutSaya['tryout']['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                            SizedBox(height: 8), // ✅ ADDED: Spacing
                            controller.tryOutSaya.isEmpty
                                ? Skeletonizer(child: Text('lorem'))
                                : controller.tryOutSaya['ispremium'] == 1
                                ? controller.tryOutSaya['expireddate'] != null
                                    ? Text("Masa Aktif")
                                    : SizedBox()
                                : Text(
                                  "Tryout ini adalah versi gratis, dan akan hilang apabila periode pengerjaan telah berakhir (${controller.formatTanggal(controller.tryOutSaya['tryout']?['startdate'])} - ${controller.formatTanggal(controller.tryOutSaya['tryout']?['enddate'])}). Silahkan upgrade ke premium agar mendapatkan tambahan masa aktif dan fitur lainnya.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                            SizedBox(height: 4), // ✅ ADDED: Spacing
                            controller.tryOutSaya['ispremium'] == 1
                                ? SizedBox(
                                  width: double.infinity,
                                  child:
                                      controller.tryOutSaya.isEmpty
                                          ? Skeletonizer(
                                            child: _badge(isi: "180 Hari"),
                                          )
                                          : controller
                                                  .tryOutSaya['expireddate'] !=
                                              null
                                          ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Progress Bar
                                              LinearProgressIndicator(
                                                value:
                                                    (controller
                                                            .tryOutSaya['tryout']['reamining_day'] /
                                                        controller
                                                            .hitungTotalMasaAktif(
                                                              controller
                                                                  .tryOutSaya['created_at'],
                                                              controller
                                                                  .tryOutSaya['expireddate'],
                                                            )
                                                            .toDouble()), // Progress 0.0 - 1.0
                                                backgroundColor:
                                                    Colors.grey.shade300,
                                                color: Colors.teal.shade300,
                                                minHeight:
                                                    12, // Tinggi progress bar
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              const SizedBox(height: 8),

                                              // Text Sisa Hari
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Sisa Hari",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${controller.tryOutSaya['tryout']['reamining_day'].toString()} Hari Lagi",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                          : SizedBox(),
                                )
                                : SizedBox(),
                            SizedBox(height: 16), // ✅ ADDED: Spacing
                            Obx(() {
                              if (controller.tryOutSaya.isEmpty) {
                                return Skeletonizer(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: Text("Loading"),
                                    ),
                                  ),
                                );
                              }

                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        controller.tryOutSaya['tryout']['startdate'] !=
                                                    null &&
                                                DateTime.parse(
                                                          controller
                                                              .tryOutSaya['tryout']['startdate'],
                                                        )
                                                        .difference(
                                                          DateTime.now(),
                                                        )
                                                        .inHours >
                                                    0
                                            ? Colors.amber
                                            : controller.tryOutSaya['isdone'] ==
                                                1
                                            ? Colors.pink
                                            : Colors.teal,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.checkList();
                                    // Logic to handle button press
                                    if (controller
                                                .tryOutSaya['tryout']['startdate'] !=
                                            null &&
                                        DateTime.parse(
                                              controller
                                                  .tryOutSaya['tryout']['startdate'],
                                            ).difference(DateTime.now()).inHours >
                                            0) {
                                      showModalBottomSheet(
                                        useSafeArea: false,
                                        backgroundColor: Colors.white,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return SafeArea(
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Padding(
                                                padding: EdgeInsets.all(32),
                                                child: Obx(
                                                  () => Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Center(
                                                        child: SvgPicture.asset(
                                                          'assets/icon/info.svg',
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Center(
                                                        child: Text(
                                                          'Tryout akan dimulai pada',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Center(
                                                        child: Text(
                                                          controller
                                                              .remaining
                                                              .value,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 20),
                                                      ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.teal,
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Get.find<
                                                                DetailTryoutSayaController
                                                              >()
                                                              .addToCalendar(
                                                                title:
                                                                    'Tryout SKD CPNS 2024',
                                                                startDate:
                                                                    DateTime.parse(
                                                                      controller
                                                                          .tryOutSaya['tryout']['startdate'],
                                                                    ), // DateTime
                                                                endDate: DateTime.parse(
                                                                  controller
                                                                      .tryOutSaya['tryout']['enddate'],
                                                                ), // DateTime
                                                                description:
                                                                    'Jangan telat ya!',
                                                                location:
                                                                    'Online',
                                                                url:
                                                                    'https://idcpns.com/app/tryout/me/${controller.uuid}',
                                                              );
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .calendar_month_outlined,
                                                              size: 18,
                                                            ),

                                                            Text(
                                                              "Tambahkan ke kalender",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 10),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: ElevatedButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            foregroundColor:
                                                                Colors.teal,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                              side: BorderSide(
                                                                color:
                                                                    Colors.teal,
                                                              ),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            "Kembali",
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      return;
                                    }
                                    if (controller.tryOutSaya['isdone'] == 1) {
                                      Get.defaultDialog(
                                        backgroundColor: Colors.white,
                                        title: "Konfirmasi",
                                        middleText:
                                            "Apakah kamu yakin ingin me-reset tryout?",
                                        textCancel: "Batal",
                                        textConfirm: "Ya, Reset",
                                        confirmTextColor: Colors.white,
                                        buttonColor: Colors.teal,
                                        onConfirm: () {
                                          controller.resetTryout();
                                          Get.back();
                                        },
                                        onCancel: () {},
                                        radius: 8,
                                      );
                                    } else {
                                      showModalBottomSheet(
                                        useSafeArea: false,
                                        backgroundColor: Colors.white,
                                        context: context,
                                        isScrollControlled:
                                            true, // biar bisa full height kalau perlu
                                        builder: (context) {
                                          return SafeArea(
                                            child: SizedBox(
                                              width:
                                                  double
                                                      .infinity, // <- kasih full width
                                              child: Padding(
                                                padding: EdgeInsets.all(32),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize
                                                          .min, // biar nggak full screen
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("Lengkapi Form"),
                                                        IconButton(
                                                          onPressed:
                                                              () =>
                                                                  Navigator.pop(
                                                                    context,
                                                                  ),
                                                          icon: Icon(
                                                            Icons.close,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 16),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "*",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text("Instansi Tujuan"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 12),
                                                    controller
                                                            .listInstansi
                                                            .isEmpty
                                                        ? Skeletonizer(
                                                          child: Text("data"),
                                                        )
                                                        : DropdownSearch<
                                                          String
                                                        >(
                                                          items: (f, cs) {
                                                            // Return Future<List<String>>
                                                            return controller
                                                                .listInstansi
                                                                .map(
                                                                  (instansi) =>
                                                                      instansi['nama']
                                                                          .toString(),
                                                                )
                                                                .toList();
                                                          },
                                                          selectedItem:
                                                              controller
                                                                          .selectedInstansi
                                                                          .value ==
                                                                      ""
                                                                  ? null
                                                                  : controller.listInstansi.firstWhere(
                                                                    (jabatan) =>
                                                                        jabatan['id']
                                                                            .toString() ==
                                                                        controller
                                                                            .selectedInstansi
                                                                            .value,
                                                                    orElse:
                                                                        () => {
                                                                          'nama':
                                                                              '',
                                                                        },
                                                                  )['nama'],

                                                          popupProps: PopupProps.dialog(
                                                            showSearchBox:
                                                                true, // ✅ Ada search bawaan
                                                            searchFieldProps: TextFieldProps(
                                                              decoration: InputDecoration(
                                                                labelText:
                                                                    'Cari Instansi',
                                                                border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            dialogProps: DialogProps(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      12,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          decoratorProps: DropDownDecoratorProps(
                                                            decoration: InputDecoration(
                                                              labelText:
                                                                  "Pilih Instansi",
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            final selected = controller
                                                                .listInstansi
                                                                .firstWhere(
                                                                  (instansi) =>
                                                                      instansi['nama']
                                                                          .toString() ==
                                                                      value,
                                                                  orElse:
                                                                      () => {},
                                                                );
                                                            controller
                                                                    .selectedInstansi
                                                                    .value =
                                                                selected['id']
                                                                    .toString();
                                                          },
                                                        ),

                                                    SizedBox(height: 12),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "*",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text("Jabatan Tujuan"),
                                                      ],
                                                    ),
                                                    SizedBox(height: 12),
                                                    controller
                                                            .listJabatan
                                                            .isEmpty
                                                        ? Skeletonizer(
                                                          child: Text("data"),
                                                        )
                                                        : DropdownSearch<
                                                          String
                                                        >(
                                                          items: (f, cs) {
                                                            // Return Future<List<String>>
                                                            return controller
                                                                .listJabatan
                                                                .map(
                                                                  (instansi) =>
                                                                      instansi['nama']
                                                                          .toString(),
                                                                )
                                                                .toList();
                                                          },
                                                          selectedItem:
                                                              controller
                                                                          .selectedJabatan
                                                                          .value ==
                                                                      ""
                                                                  ? null
                                                                  : controller.listJabatan.firstWhere(
                                                                    (jabatan) =>
                                                                        jabatan['id']
                                                                            .toString() ==
                                                                        controller
                                                                            .selectedJabatan
                                                                            .value,
                                                                    orElse:
                                                                        () => {
                                                                          'nama':
                                                                              '',
                                                                        },
                                                                  )['nama'],
                                                          popupProps: PopupProps.dialog(
                                                            showSearchBox:
                                                                true, // ✅ Ada search bawaan
                                                            searchFieldProps: TextFieldProps(
                                                              decoration: InputDecoration(
                                                                labelText:
                                                                    'Cari Jabatan',
                                                                border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        8,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            dialogProps: DialogProps(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      12,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          decoratorProps: DropDownDecoratorProps(
                                                            decoration: InputDecoration(
                                                              labelText:
                                                                  "Pilih Jabatan",
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            final selected = controller
                                                                .listJabatan
                                                                .firstWhere(
                                                                  (instansi) =>
                                                                      instansi['nama']
                                                                          .toString() ==
                                                                      value,
                                                                  orElse:
                                                                      () => {},
                                                                );
                                                            controller
                                                                    .selectedJabatan
                                                                    .value =
                                                                selected['id']
                                                                    .toString();
                                                          },
                                                        ),

                                                    SizedBox(height: 24),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.teal,
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 12,
                                                              ),
                                                        ),
                                                        onPressed: () {
                                                          if (controller
                                                                      .selectedInstansi
                                                                      .value ==
                                                                  "" ||
                                                              controller
                                                                      .selectedInstansi
                                                                      .value ==
                                                                  "0") {
                                                            Get.snackbar(
                                                              "Gagal",
                                                              "Mohon pilih instansi tujuan anda",
                                                              backgroundColor:
                                                                  Colors.pink,
                                                              colorText:
                                                                  Colors.white,
                                                            );
                                                            return;
                                                          }
                                                          if (controller
                                                                      .selectedJabatan
                                                                      .value ==
                                                                  "" ||
                                                              controller
                                                                      .selectedJabatan
                                                                      .value ==
                                                                  "0") {
                                                            Get.snackbar(
                                                              "Gagal",
                                                              "Mohon pilih jabatan tujuan anda",
                                                              backgroundColor:
                                                                  Colors.pink,
                                                              colorText:
                                                                  Colors.white,
                                                            );
                                                            return;
                                                          }

                                                          controller
                                                              .localStorage
                                                              .setString(
                                                                'jabatan',
                                                                controller
                                                                    .selectedJabatan
                                                                    .value,
                                                              );
                                                          controller
                                                              .localStorage
                                                              .setString(
                                                                'instansi',
                                                                controller
                                                                    .selectedInstansi
                                                                    .value,
                                                              );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          Get.toNamed(
                                                            "/detail-pengerjaan-tryout",
                                                          );
                                                          controller
                                                                  .uuid
                                                                  .value =
                                                              controller
                                                                  .lateUuid;
                                                        },
                                                        child: Text(
                                                          "Lanjutkan Tryout",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Text(
                                    controller.tryOutSaya['tryout']['startdate'] !=
                                                null &&
                                            DateTime.parse(
                                                      controller
                                                          .tryOutSaya['tryout']['startdate'],
                                                    )
                                                    .difference(DateTime.now())
                                                    .inHours >
                                                0
                                        ? "Tryout Belum Dimulai"
                                        : controller.tryOutSaya['isdone'] == 1
                                        ? "Ulangi Tryout"
                                        : "Kerjakan Tryout",
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Other widgets remain the same...
                  // Make sure to apply the `colorFilter` fix to all your SVGs.
                  // Example for the 'Rapor' button:
                  Obx(() => _buildFeatureButtons()),
                  SizedBox(height: 16),
                  // If the tryout is not done, show a message. Otherwise, show the charts.
                  Obx(() {
                    if (controller.nilaiChart.isEmpty) {
                      return const SizedBox();
                    } else {
                      if (controller.loading['chart'] == true) {
                        return Skeletonizer(
                          child: _buildPlaceholder(
                            "Kerjakan tryout untuk melihat hasil dan statistik.",
                          ),
                        );
                      } else {
                        if (controller.tryOutSaya['isdone'] == 1) {
                          return Column(
                            children: [_totalNilai(), _buildResultCharts()],
                          );
                        } else {
                          return _buildPlaceholder(
                            "Kerjakan tryout untuk melihat hasil dan statistik.",
                          );
                        }
                      }
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for the placeholder text
  Widget _buildPlaceholder(String message) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ),
    );
  }

  Widget _passingGrade({
    required String title,
    required String score,
    required String passingGrade,
  }) {
    return Card(
      color:
          int.parse(score) > int.parse(passingGrade)
              ? Colors.teal.shade100
              : Colors.pink.shade100,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color:
                    int.parse(score) > int.parse(passingGrade)
                        ? Colors.teal
                        : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 12),
            Text(
              score,
              style: TextStyle(
                color:
                    int.parse(score) > int.parse(passingGrade)
                        ? Colors.teal
                        : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Passing Grade: ",
                  style: TextStyle(
                    color:
                        int.parse(score) > int.parse(passingGrade)
                            ? Colors.teal
                            : Colors.red,
                  ),
                ),
                Text(
                  passingGrade,
                  style: TextStyle(
                    color:
                        int.parse(score) > int.parse(passingGrade)
                            ? Colors.teal
                            : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalNilai() {
    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Obx(() {
              final labels = controller.nilaiChart['charts']['labels'] as List;
              final values = controller.nilaiChart['charts']['values'] as List;

              // Cek apakah semua value 0
              final allZero = values.every(
                (value) => int.tryParse(value.toString()) == 0,
              );

              // Data yang akan ditampilkan di chart
              final List<ChartData> chartData =
                  allZero
                      ? [
                        ChartData(
                          "Tidak ada data",
                          "1",
                          Colors.grey.shade300, // Placeholder abu-abu
                        ),
                      ]
                      : List.generate(
                        labels.length,
                        (i) => ChartData(
                          labels[i], // Label: TWK, TIU, TKP
                          values[i],
                          Colors.primaries[i %
                              Colors.primaries.length], // Warna dinamis
                        ),
                      );

              return SfCircularChart(
                title: ChartTitle(
                  text: "Total Nilai",
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                legend: const Legend(
                  isVisible: true, // ✅ Menampilkan legenda
                  position: LegendPosition.bottom, // Posisi di bawah
                  overflowMode:
                      LegendItemOverflowMode.wrap, // Bungkus kalau kepanjangan
                  textStyle: TextStyle(fontSize: 12),
                ),
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper:
                        (ChartData data, _) => int.tryParse(data.y) ?? 0,
                    pointColorMapper: (ChartData data, _) => data.color,
                    innerRadius: '80%',
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true, // ✅ Menampilkan label
                      labelPosition: ChartDataLabelPosition.outside,
                      overflowMode: OverflowMode.shift,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),

        const SizedBox(height: 16),
        Obx(() {
          return Container(
            child: Column(
              children:
                  controller.nilaiChart['statistics'].map<Widget>((data) {
                    return _passingGrade(
                      title: data['title'],
                      score: data['result_nilai'].toString(),
                      passingGrade: data['nilai'].toString(),
                    );
                  }).toList(), // ✅ Convert ke List<Widget>
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResultCharts() {
    return Column(
      children: [
        const SizedBox(height: 16),

        // Bar Chart untuk Benar / Salah / Kosong
        Stack(
          children: [
            IgnorePointer(
              ignoring: controller.tryOutSaya['ispremium'] != 1,
              child: Obx(() {
                return Card(
                  color: Colors.white,
                  elevation: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    child: Column(
                      children: [
                        SfCartesianChart(
                          title: ChartTitle(
                            text: "Waktu Pengerjaan",
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          primaryXAxis: CategoryAxis(
                            labelRotation: -45,
                            majorGridLines: const MajorGridLines(width: 0),
                          ),
                          primaryYAxis: NumericAxis(
                            minimum: 0,
                            labelRotation: 0,
                            title: AxisTitle(text: 'Waktu(Detik)'),
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <ColumnSeries>[
                            ColumnSeries<ChartData, String>(
                              dataSource: controller.chartDataList,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper:
                                  (ChartData data, _) => int.tryParse(data.y),
                              pointColorMapper:
                                  (ChartData data, _) => data.color,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            spacing: 16,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Total Waktu: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${(controller.totalValue.value / 60).toStringAsFixed(2)} Menit",
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            spacing: 16,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Rata - Rata Waktu: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${((controller.totalValue.value / controller.tryOutSaya['tryout']['jumlah_soal'])).toStringAsFixed(2)} Detik",
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
            IgnorePointer(
              ignoring: controller.tryOutSaya['ispremium'] != 1,
              child: Obx(
                () =>
                    controller.nilaiChartStat.isEmpty
                        ? const Skeletonizer(child: Text("data"))
                        : Column(
                          children:
                              (controller.nilaiChartStat['statistics']
                                      as List<dynamic>)
                                  .map((item) {
                                    final subcategories =
                                        item['subcategories'] as List<dynamic>;

                                    // Calculate totals for Benar, Salah, and Kosong
                                    final totalBenar = subcategories.fold(
                                      0,
                                      (sum, sub) => sum + (sub['benar'] as int),
                                    );
                                    final totalSalah = subcategories.fold(
                                      0,
                                      (sum, sub) => sum + (sub['salah'] as int),
                                    );
                                    final totalKosong = subcategories.fold(
                                      0,
                                      (sum, sub) =>
                                          sum + (sub['kosong'] as int),
                                    );

                                    // Ubah subcategories menjadi list ChartData
                                    final chartData =
                                        subcategories
                                            .map((sub) {
                                              return [
                                                ChartData(
                                                  "${sub['title']} (Benar)",
                                                  sub['benar'].toString(),
                                                  Colors.green,
                                                ),
                                                ChartData(
                                                  "${sub['title']} (Salah)",
                                                  sub['salah'].toString(),
                                                  Colors.red,
                                                ),
                                                ChartData(
                                                  "${sub['title']} (Kosong)",
                                                  sub['kosong'].toString(),
                                                  Colors.orange,
                                                ),
                                              ];
                                            })
                                            .expand((e) => e)
                                            .toList();

                                    return Card(
                                      color: Colors.white,
                                      elevation: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical:
                                              16, // Add vertical padding to the card
                                          horizontal: 16,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start, // Align totals to the start
                                          children: [
                                            // Display total values above the chart
                                            Text(
                                              item['label'], // e.g., "TWK"
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              children: [
                                                Row(
                                                  spacing: 8,
                                                  children: [
                                                    Icon(
                                                      Icons.stacked_bar_chart,
                                                      color: Colors.teal,
                                                    ),
                                                    Text(
                                                      "Benar: $totalBenar",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  spacing: 8,
                                                  children: [
                                                    Icon(
                                                      Icons.stacked_bar_chart,
                                                      color: Colors.pink,
                                                    ),
                                                    Text(
                                                      "Salah: $totalSalah",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  spacing: 8,
                                                  children: [
                                                    Icon(
                                                      Icons.stacked_bar_chart,
                                                      color: Colors.grey,
                                                    ),
                                                    Text(
                                                      "Kosong: $totalKosong",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            // Chart untuk masing-masing label seperti TWK, TIU, TKP
                                            SfCartesianChart(
                                              title: ChartTitle(
                                                text:
                                                    "Statistik Jawaban", // Update title to be more general
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              legend: Legend(
                                                isVisible: false,
                                                position: LegendPosition.bottom,
                                              ),
                                              tooltipBehavior: TooltipBehavior(
                                                enable: true,
                                              ),
                                              primaryXAxis: CategoryAxis(
                                                labelRotation: 0,
                                                labelStyle: const TextStyle(
                                                  fontSize: 10,
                                                ),
                                                majorGridLines:
                                                    const MajorGridLines(
                                                      width: 0,
                                                    ),
                                              ),
                                              primaryYAxis: NumericAxis(
                                                minimum: 0,
                                                title: AxisTitle(
                                                  text: 'Jumlah Soal',
                                                ),
                                              ),
                                              series: <
                                                StackedBarSeries<
                                                  dynamic,
                                                  String
                                                >
                                              >[
                                                // Benar
                                                StackedBarSeries<
                                                  dynamic,
                                                  String
                                                >(
                                                  name: 'Benar',
                                                  color: Colors.teal,
                                                  dataSource: subcategories,
                                                  xValueMapper:
                                                      (data, _) =>
                                                          data['title'],
                                                  yValueMapper:
                                                      (data, _) =>
                                                          data['benar'],
                                                  dataLabelSettings:
                                                      const DataLabelSettings(
                                                        isVisible: true,
                                                      ),
                                                ),
                                                // Salah
                                                StackedBarSeries<
                                                  dynamic,
                                                  String
                                                >(
                                                  name: 'Salah',
                                                  color: Colors.pink,
                                                  dataSource: subcategories,
                                                  xValueMapper:
                                                      (data, _) =>
                                                          data['title'],
                                                  yValueMapper:
                                                      (data, _) =>
                                                          data['salah'],
                                                  dataLabelSettings:
                                                      const DataLabelSettings(
                                                        isVisible: true,
                                                      ),
                                                ),
                                                // Kosong
                                                StackedBarSeries<
                                                  dynamic,
                                                  String
                                                >(
                                                  name: 'Kosong',
                                                  color: Colors.grey,
                                                  dataSource: subcategories,
                                                  xValueMapper:
                                                      (data, _) =>
                                                          data['title'],
                                                  yValueMapper:
                                                      (data, _) =>
                                                          data['kosong'],
                                                  dataLabelSettings:
                                                      const DataLabelSettings(
                                                        isVisible: true,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                        ),
              ),
            ),

            if (controller.tryOutSaya['ispremium'] != 1)
              Positioned.fill(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'Upgrade ke premium untuk menikmati semua fitur yang ada',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                            '/tryout-event-payment',
                            arguments: [
                              controller.tryOutSaya['tryout']['uuid'],
                              controller.lateUuid.toString(),
                            ],
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                        ),
                        child: Text("Upgrade Premium"),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  // Helper for Rapor, Peringkat, Pembahasan buttons
  Widget _buildFeatureButtons() {
    bool isDone = controller.tryOutSaya['isdone'] == 1;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: controller.tryOutSaya['ispremium'] != 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _featureButton(
                  "Rapor",
                  "assets/report.svg",
                  Color(0xFF00A693),
                  isDone,
                  "/rapor",
                ),
                _featureButton(
                  "Peringkat",
                  "assets/trophy.svg",
                  Color(0xFFFFA800),
                  isDone,
                  "/peringkat-tryout",
                ),
                _featureButton(
                  "Pembahasan",
                  "assets/book.svg",
                  Color(0xFF00A8C5),
                  isDone,
                  "pembahasan-tryout",
                ),
              ],
            ),
          ),

          if (controller.tryOutSaya['ispremium'] != 1)
            IntrinsicHeight(
              child: Positioned.fill(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      Text(
                        'Upgrade ke premium untuk menikmati semua fitur yang ada',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                            '/tryout-event-payment',
                            arguments: [
                              controller.tryOutSaya['tryout']['uuid'],
                              controller.lateUuid.toString(),
                            ],
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                        ),
                        child: Text("Upgrade Premium"),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _featureButton(
    String label,
    String assetPath,
    Color activeColor,
    bool isEnabled,
    String route,
  ) {
    return InkWell(
      onTap:
          isEnabled
              ? () {
                Get.toNamed(route, arguments: controller.tryOutSaya['uuid']);
              }
              : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              isEnabled ? activeColor.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled ? activeColor : Colors.grey.shade300,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              width: 32,
              // ✅ FIXED: Use colorFilter instead of the deprecated color property
              colorFilter: ColorFilter.mode(
                isEnabled ? activeColor : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isEnabled ? activeColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge({
    required String? isi,
    Color backgroundColor = Colors.grey,
    Color foregroundColor = Colors.white,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Center(
          child: Text(
            isi ?? '',
            style: TextStyle(color: foregroundColor, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
