import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:idcpns_mobile/app/routes/app_pages.dart';

void main() {
  testWidgets('App loads with initial route', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );

    // Tunggu sampai frame pertama selesai
    await tester.pumpAndSettle();

    // Pastikan halaman awal tampil (contoh: login atau dashboard)
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
