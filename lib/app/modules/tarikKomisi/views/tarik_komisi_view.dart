import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/tarik_komisi_controller.dart';

class TarikKomisiView extends GetView<TarikKomisiController> {
  const TarikKomisiView({super.key});
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
          "Tarik Komisi",
          onBack: () {
            Get.offNamed(Routes.AFFILIATE);
          },
        ),
        body: SafeArea(
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.teal,
            onRefresh: () => controller.refresh(),
            child: Obx(() {
              final isValid = controller.nominalValue.value >= 500000;
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: AppStyle.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Informasi', style: AppStyle.styleW900),
                          SizedBox(height: 12),
                          ...controller.informationPoints
                              .map(
                                (point) => Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
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
                          Text('Tarik Komisi', style: AppStyle.styleW900),
                          SizedBox(height: 16),
                          Text(
                            'Nominal',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: controller.nominalController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Masukkan Nominal',
                              errorText:
                                  isValid || controller.nominalValue.value == 0
                                      ? null
                                      : 'Minimal penarikan Rp.500.000',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Rekening',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 5),
                          DropdownSearch<int>(
                            items: (String? filter, LoadProps? props) {
                              return controller.bankList
                                  .map<int>((item) => item['id'] as int)
                                  .toList();
                            },
                            selectedItem:
                                controller.rekeningId.value == 0
                                    ? null
                                    : controller.rekeningId.value,
                            itemAsString: (int id) {
                              final selected = controller.bankList.firstWhere(
                                (item) => item['id'] == id,
                                orElse: () => {},
                              );
                              return selected.isNotEmpty
                                  ? "${selected['bank_name']} - ${selected['no_rekening']}"
                                  : '';
                            },
                            popupProps: PopupProps.menu(
                              // ⬅️ ganti jadi menu
                              fit: FlexFit.loose,
                              showSelectedItems: true,
                              menuProps: MenuProps(
                                backgroundColor: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                elevation: 2,
                              ),
                            ),
                            decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                labelText: "Rekening",
                                hintText: "Pilih Rekening",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                isDense: true,
                              ),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                final selected = controller.bankList.firstWhere(
                                  (item) => item['id'] == value,
                                );
                                controller.rekeningId.value = selected['id'];
                                controller.rekeningNum.value =
                                    selected['no_rekening'];
                              }
                            },
                          ),

                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  controller.nominalController.clear();
                                  controller.nominalValue.value = 0;
                                  controller.rekeningNum.value =
                                      ""; // reset dropdown
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  side: BorderSide(color: Colors.teal),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Text(
                                  'Batal',
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Obx(() {
                                final isValid =
                                    controller.nominalValue.value >= 500000;
                                return ElevatedButton(
                                  onPressed:
                                      isValid
                                          ? () => controller.postMutasi()
                                          : null,
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        isValid ? Colors.teal : Colors.grey,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.MUTASI_SALDO);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lihat riwayat penarikan komisi',
                              style: TextStyle(fontSize: 15),
                            ),

                            IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.teal,
                              ),
                              onPressed: () {
                                Get.toNamed(Routes.MUTASI_SALDO);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
