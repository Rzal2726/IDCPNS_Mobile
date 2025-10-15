import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // false = cegah pop otomatis
      onPopInvoked: (didPop) async {
        if (didPop) return;
        Get.offNamed(Routes.HOME, arguments: {'initialIndex': 4});
        // (Get.find<HomeController>()).currentIndex.value = 4;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "Ubah kata sandi",
          onBack: () {
            Get.offNamed(Routes.HOME, arguments: {'initialIndex': 4});
            // (Get.find<HomeController>()).currentIndex.value = 4;
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: AppStyle.screenPadding,
            child: Align(
              alignment: Alignment.topCenter, // posisikan card di atas tengah
              child: Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ubah kata sandi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Kata Sandi Lama
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => TextField(
                              controller: controller.oldPasswordController,
                              obscureText: controller.isOldPasswordHidden.value,
                              decoration: InputDecoration(
                                hintText: "Masukan kata sandi lama",
                                labelText: "Kata sandi lama",
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                isDense: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isOldPasswordHidden.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: controller.toggleOldPassword,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Obx(
                            () => TextField(
                              controller: controller.newPasswordController,
                              obscureText: controller.isNewPasswordHidden.value,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black),
                                hintText: "Masukan kata sandi baru",
                                labelText: "Kata sandi baru",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                isDense: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    color: Colors.grey,
                                    controller.isNewPasswordHidden.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: controller.toggleNewPassword,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Obx(
                            () => TextField(
                              controller: controller.confirmPasswordController,
                              obscureText:
                                  controller.isConfirmPasswordHidden.value,
                              decoration: InputDecoration(
                                hintText: "Masukan Konfirmasi Kata sandi baru",
                                labelStyle: TextStyle(color: Colors.black),
                                labelText: "Konfirmasi Kata sandi baru",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                isDense: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    color: Colors.grey,
                                    controller.isConfirmPasswordHidden.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: controller.toggleConfirmPassword,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: controller.changePassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  6,
                                ), // sudut sedikit membulat
                              ),
                            ),
                            child: Text(
                              "Simpan",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
