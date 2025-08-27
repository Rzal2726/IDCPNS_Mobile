import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/affiliate/bindings/affiliate_binding.dart';
import '../modules/affiliate/views/affiliate_view.dart';
import '../modules/changePassword/bindings/change_password_binding.dart';
import '../modules/changePassword/views/change_password_view.dart';
import '../modules/commisionDetail/bindings/commision_detail_binding.dart';
import '../modules/commisionDetail/views/commision_detail_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/detail_tryout/bindings/detail_tryout_binding.dart';
import '../modules/detail_tryout/views/detail_tryout_view.dart';
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
import '../modules/programSaya/bindings/program_saya_binding.dart';
import '../modules/programSaya/views/program_saya_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/transaction/bindings/transaction_binding.dart';
import '../modules/transaction/views/transaction_view.dart';
import '../modules/tryout/bindings/tryout_binding.dart';
import '../modules/tryout/views/tryout_view.dart';
import '../modules/tryout_payment/bindings/tryout_payment_binding.dart';
import '../modules/tryout_payment/views/tryout_payment_view.dart';
import '../modules/tryout_saya/bindings/tryout_saya_binding.dart';
import '../modules/tryout_saya/views/tryout_saya_view.dart';
import '../modules/wishlist/bindings/wishlist_binding.dart';
import '../modules/wishlist/views/wishlist_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

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
      name: _Paths.WISHLIST,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: _Paths.PROGRAM_SAYA,
      page: () => const ProgramSayaView(),
      binding: ProgramSayaBinding(),
    ),
    GetPage(
      name: _Paths.AFFILIATE,
      page: () => const AffiliateView(),
      binding: AffiliateBinding(),
    ),
    GetPage(
      name: _Paths.COMMISION_DETAIL,
      page: () => const CommisionDetailView(),
      binding: CommisionDetailBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
