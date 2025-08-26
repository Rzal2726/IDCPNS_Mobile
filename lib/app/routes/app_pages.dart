import 'package:get/get.dart';

import '../modules/detail_tryout/bindings/detail_tryout_binding.dart';
import '../modules/detail_tryout/views/detail_tryout_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/tryout/bindings/tryout_binding.dart';
import '../modules/tryout/views/tryout_view.dart';
import '../modules/tryout_payment/bindings/tryout_payment_binding.dart';
import '../modules/tryout_payment/views/tryout_payment_view.dart';
import '../modules/tryout_saya/bindings/tryout_saya_binding.dart';
import '../modules/tryout_saya/views/tryout_saya_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.TRYOUT;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TRYOUT,
      page: () => TryoutView(),
      binding: TryoutBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_TRYOUT,
      page: () => DetailTryoutView(),
      binding: DetailTryoutBinding(),
    ),
    GetPage(
      name: _Paths.TRYOUT_PAYMENT,
      page: () => TryoutPaymentView(),
      binding: TryoutPaymentBinding(),
    ),
    GetPage(
      name: _Paths.TRYOUT_SAYA,
      page: () => TryoutSayaView(),
      binding: TryoutSayaBinding(),
    ),
  ];
}
