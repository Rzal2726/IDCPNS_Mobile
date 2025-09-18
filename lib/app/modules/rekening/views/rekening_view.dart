import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/rekening_controller.dart';

class RekeningView extends GetView<RekeningController> {
  const RekeningView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar(
        "Afiliasi",
        onBack: () {
          Get.back();
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                                color: Colors.grey,
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
              controller.rekeningUserData.length < 3
                  ? Container(
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
                        Text('Tambah Rekening Bank', style: AppStyle.styleW900),
                        SizedBox(height: 40),
                        Text('Bank', style: TextStyle(color: Colors.black)),
                        SizedBox(height: 4),
                        Obx(() {
                          return DropdownButtonFormField<String>(
                            value:
                                controller.selectedBankName.value.isEmpty
                                    ? null
                                    : controller.selectedBankName.value,
                            items:
                                controller.bankList
                                    .map(
                                      (bank) => DropdownMenuItem<String>(
                                        value: bank['name'],
                                        child: Text(bank['name']),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedBankName.value = value;

                                // ambil id sesuai nama yang dipilih
                                final selected = controller.bankList.firstWhere(
                                  (bank) => bank['name'] == value,
                                );
                                controller.bankId.value = selected['id'];
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                            ),
                            hint: Text('Pilih Bank'),
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
                  )
                  : SizedBox.shrink(),

              SizedBox(height: 24),

              Obx(() {
                return Visibility(
                  visible: controller.rekeningUserData.isNotEmpty,
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
                        Text('Rekening Anda', style: AppStyle.styleW900),
                        SizedBox(height: 40),
                        for (var data in controller.rekeningUserData)
                          Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey.shade300),
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
                                        style: AppStyle.style17Bold,
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
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
