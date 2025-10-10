import 'package:flutter/material.dart';
import 'package:get/get.dart';

void offNamedUntilAny(
  String target,
  Iterable<String> stopAt, {
  dynamic arguments,
  Map<String, String>? parameters,
}) {
  Get.offNamedUntil(
    target,
    (route) => stopAt.contains(route.settings.name),
    arguments: arguments,
    parameters: parameters,
  );
}
