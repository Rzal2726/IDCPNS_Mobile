import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TryoutHarianController extends GetxController {
  //TODO: Implement TryoutHarianController

  final count = 0.obs;
  DateTime today = DateTime.now();

  RxList<Map<String, dynamic>> categories =
      [
        {"title": "CPNS", "iconColor": Colors.red, "showDot": true},
        {"title": "BUMN", "iconColor": Colors.transparent, "showDot": false},
        {
          "title": "Kedinasan",
          "iconColor": Colors.transparent,
          "showDot": false,
        },
        {"title": "PPPK", "iconColor": Colors.transparent, "showDot": false},
      ].obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    today = selectedDay;
  }
}
