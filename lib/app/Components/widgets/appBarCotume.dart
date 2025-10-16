import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifIcon.dart';
import 'package:idcpns_mobile/app/Components/widgets/runningTextWidget.dart';
import 'package:idcpns_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:idcpns_mobile/app/modules/notification/controllers/notification_controller.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

enum AppBarLeftType { logo, back, backWithTitle, title }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarLeftType leftType;
  final String? title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool showNotifIcon;
  final bool showRunningText; // 🆕

  const CustomAppBar({
    Key? key,
    this.title,
    this.onBack,
    this.actions,
    this.leftType = AppBarLeftType.back,
    this.showNotifIcon = false,
    this.showRunningText = false, // 🆕 default false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          // ⬆️ Ini “announcement bar” kamu
          if (showRunningText) RunningTextBar(), // widget kamu yang sebelumnya
          // 🧱 AppBar tetap jadi bagian dari PreferredSize
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleSpacing: 0,
            title: Row(
              children: [
                SizedBox(width: 8),
                if (leftType == AppBarLeftType.logo) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: InkWell(
                      onTap: () {
                        (Get.find<HomeController>()).changeBottomBar(0);
                        Get.find<HomeController>().currentIndex.value = 0;
                      },
                      child: Image.asset('assets/logo.png', height: 50),
                    ),
                  ),
                ],
                if (leftType == AppBarLeftType.back) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: onBack ?? () => Get.back(),
                    ),
                  ),
                ],
                if (leftType == AppBarLeftType.backWithTitle) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        final notifC = Get.put(NotificationController());
                        if (onBack != null) {
                          onBack!();
                        } else {
                          Get.back();
                        }
                        notifC.getNotif();
                      },
                    ),
                  ),
                  if (title != null)
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
                if (leftType == AppBarLeftType.title && title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              if (showNotifIcon) NotifIcon(),
              if (actions != null) ...actions!,
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (showRunningText ? 32 : 0));
}

/// 🔥 Shortcut Template
CustomAppBar basicAppBar() {
  return CustomAppBar(
    leftType: AppBarLeftType.logo,
    showNotifIcon: true,
    showRunningText: true,
  );
}

CustomAppBar secondaryAppBar(String title, {VoidCallback? onBack}) {
  return CustomAppBar(
    leftType: AppBarLeftType.backWithTitle,
    title: title,
    onBack: () {
      if (onBack != null) {
        onBack();
      } else {
        Get.back(); // default behavior
      }
    },
    showNotifIcon: true,
    // showRunningText: true,
  );
}

CustomAppBar basicAppBarWithoutNotif(String title, {VoidCallback? onBack}) {
  return CustomAppBar(
    leftType: AppBarLeftType.backWithTitle,
    title: title,
    onBack: () {
      NotifIcon();
      Get.back();
    },
  );
}
