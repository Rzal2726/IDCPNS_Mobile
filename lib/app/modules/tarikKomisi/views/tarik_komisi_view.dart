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
          Get.toNamed(Routes.AFFILIATE);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "Tarik Komisi",
          onBack: () {
            Get.toNamed(Routes.AFFILIATE);
          },
        ),
        body: SafeArea(
          child: Obx(() {
            final isValid = controller.nominalValue.value >= 500000;
            return SingleChildScrollView(
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
                        Text('Nominal', style: TextStyle(color: Colors.black)),
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
                        Text('Rekening', style: TextStyle(color: Colors.black)),
                        SizedBox(height: 5),
                        DropdownButtonFormField<int>(
                          value:
                              controller.rekeningId.value == 0
                                  ? null
                                  : controller.rekeningId.value,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            hintText: 'Pilih Rekening',
                          ),
                          items:
                              controller.bankList
                                  .map(
                                    (item) => DropdownMenuItem<int>(
                                      value: item['id'], // pake id biar unik
                                      child: Text(
                                        "${item['bank_name']} - ${item['no_rekening']}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            final selected = controller.bankList.firstWhere(
                              (item) => item['id'] == value,
                            );
                            controller.rekeningId.value = selected['id'];
                            controller.rekeningNum.value =
                                selected['no_rekening'];
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
                            icon: Icon(Icons.arrow_forward, color: Colors.teal),
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
    );
  }
}
