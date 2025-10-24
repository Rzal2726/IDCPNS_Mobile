import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/rekening_controller.dart';

class RekeningView extends GetView<RekeningController> {
  const RekeningView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // false supaya tidak auto-pop
      onPopInvoked: (didPop) {
        if (!didPop) {
          Get.offNamed(Routes.AFFILIATE);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "Rekening",
          onBack: () {
            Get.offNamed(Routes.AFFILIATE);
          },
        ),
        body: SafeArea(
          child: RefreshIndicator(
            color: Colors.teal,
            backgroundColor: Colors.white,
            onRefresh: () => controller.refresh(),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: AppStyle.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      ...controller.informationPoints
                          .map(
                            (point) => Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.teal,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      point,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
                  SizedBox(height: 24),
                  Obx(() {
                    final isLoading = controller.isLoading;
                    final canAdd = controller.rekeningUserData.length < 3;

                    if (controller.isLoading == true) {
                      // 🦴 Skeleton loading state
                      return Skeletonizer(
                        enabled: true,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: 150,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 40),
                              Container(
                                height: 16,
                                width: 100,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 48,
                                width: double.infinity,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 16),
                              Container(
                                height: 16,
                                width: 100,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 48,
                                width: double.infinity,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 16),
                              Container(
                                height: 16,
                                width: 120,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 8),
                              Container(
                                height: 48,
                                width: double.infinity,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 24),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // ✅ Kalau gak loading dan masih bisa tambah rekening
                    if (canAdd) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tambah Rekening Bank',
                              style: AppStyle.styleW900,
                            ),
                            SizedBox(height: 40),
                            Text('Bank', style: TextStyle(color: Colors.black)),
                            SizedBox(height: 4),
                            Obx(() {
                              return DropdownSearch<String>(
                                items: (String? filter, LoadProps? props) {
                                  return controller.bankList
                                      .where(
                                        (bank) =>
                                            filter == null ||
                                            bank['name']
                                                .toString()
                                                .toLowerCase()
                                                .contains(filter.toLowerCase()),
                                      )
                                      .map<String>(
                                        (bank) => bank['name'].toString(),
                                      )
                                      .toList();
                                },
                                selectedItem:
                                    controller.selectedBankName.value.isEmpty
                                        ? null
                                        : controller.selectedBankName.value,
                                itemAsString: (String name) => name,
                                popupProps: PopupProps.dialog(
                                  showSearchBox: true,
                                  fit: FlexFit.loose,
                                  dialogProps: DialogProps(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                decoratorProps: DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    labelText: "Bank",
                                    hintText: "Pilih Bank",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    isDense: true,
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.selectedBankName.value = value;
                                    final selected = controller.bankList
                                        .firstWhere(
                                          (bank) => bank['name'] == value,
                                        );
                                    controller.bankId.value = selected['id'];
                                  }
                                },
                              );
                            }),
                            SizedBox(height: 16),
                            Text(
                              'No. Rekening',
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(height: 4),
                            TextField(
                              controller: controller.accountNumberController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Masukkan No. Rekening',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Nama Pemilik',
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(height: 4),
                            TextField(
                              controller: controller.ownerNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Masukkan Nama Pemilik',
                              ),
                            ),
                            SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: controller.saveAccount,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text('Simpan'),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return SizedBox.shrink();
                  }),
                  SizedBox(height: 24),

                  Obx(() {
                    final hasRekening = controller.rekeningUserData.isNotEmpty;

                    // 🩶 Kondisi loading → tampilkan skeleton dulu
                    if (controller.isLoading == true) {
                      return Skeletonizer(
                        enabled: true,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 20,
                                width: 150,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 40),
                              // 🦴 Skeleton untuk 2-3 rekening dummy
                              for (int i = 0; i < 3; i++)
                                Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 16,
                                              width: 120,
                                              color: Colors.grey[300],
                                            ),
                                            SizedBox(height: 6),
                                            Container(
                                              height: 14,
                                              width: 180,
                                              color: Colors.grey[300],
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              height: 14,
                                              width: 160,
                                              color: Colors.grey[300],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }

                    // ✅ Kalau sudah tidak loading dan ada data rekening
                    if (hasRekening) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rekening Anda', style: AppStyle.styleW900),
                            SizedBox(height: 40),
                            for (var data in controller.rekeningUserData)
                              Container(
                                margin: EdgeInsets.only(bottom: 12),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.credit_card,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['bank_name'] ?? '',
                                            style: AppStyle.style20Bold,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            data['no_rekening'] ?? '',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            data['nama_pemilik'] ?? '',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    }

                    return SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
