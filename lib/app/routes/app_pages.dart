import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/changePassword/bindings/change_password_binding.dart';
import '../modules/changePassword/views/change_password_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/detail_pengerjaan_tryout/bindings/detail_pengerjaan_tryout_binding.dart';
import '../modules/detail_pengerjaan_tryout/views/detail_pengerjaan_tryout_view.dart';
import '../modules/detail_tryout/bindings/detail_tryout_binding.dart';
import '../modules/detail_tryout/views/detail_tryout_view.dart';
import '../modules/detail_tryout_saya/bindings/detail_tryout_saya_binding.dart';
import '../modules/detail_tryout_saya/views/detail_tryout_saya_view.dart';
import '../modules/emailVerification/bindings/email_verification_binding.dart';
import '../modules/emailVerification/views/email_verification_view.dart';
import '../modules/forgetPassword/bindings/forget_password_binding.dart';
import '../modules/forgetPassword/views/forget_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/myAccount/bindings/my_account_binding.dart';
import '../modules/myAccount/views/my_account_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/panduan_tryout/bindings/panduan_tryout_binding.dart';
import '../modules/panduan_tryout/views/panduan_tryout_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/transaction/bindings/transaction_binding.dart';
import '../modules/transaction/views/transaction_view.dart';
import '../modules/tryout/bindings/tryout_binding.dart';
import '../modules/tryout/views/tryout_view.dart';
import '../modules/tryout_checkout/bindings/tryout_checkout_binding.dart';
import '../modules/tryout_checkout/views/tryout_checkout_view.dart';
import '../modules/tryout_payment/bindings/tryout_payment_binding.dart';
import '../modules/tryout_payment/views/tryout_payment_view.dart';
import '../modules/tryout_saya/bindings/tryout_saya_binding.dart';
import '../modules/tryout_saya/views/tryout_saya_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DETAIL_TRYOUT_SAYA;

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
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.EMAIL_VERIFICATION,
      page: () => const EmailVerificationView(),
      binding: EmailVerificationBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.MY_ACCOUNT,
      page: () => const MyAccountView(),
      binding: MyAccountBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION,
      page: () => const TransactionView(),
      binding: TransactionBinding(),
    ),
    GetPage(
      name: _Paths.TRYOUT_CHECKOUT,
      page: () => TryoutCheckoutView(),
      binding: TryoutCheckoutBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_TRYOUT_SAYA,
      page: () => const DetailTryoutSayaView(),
      binding: DetailTryoutSayaBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PENGERJAAN_TRYOUT,
      page: () => const DetailPengerjaanTryoutView(),
      binding: DetailPengerjaanTryoutBinding(),
    ),
    GetPage(
      name: _Paths.PANDUAN_TRYOUT,
      page: () => const PanduanTryoutView(),
      binding: PanduanTryoutBinding(),
    ),
  ];
}
