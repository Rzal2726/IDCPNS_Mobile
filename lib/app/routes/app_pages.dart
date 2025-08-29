import 'package:get/get.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/affiliate/bindings/affiliate_binding.dart';
import '../modules/affiliate/views/affiliate_view.dart';
import '../modules/bimbel/bindings/bimbel_binding.dart';
import '../modules/bimbel/views/bimbel_view.dart';
import '../modules/bimbelRicord/bindings/bimbel_ricord_binding.dart';
import '../modules/bimbelRicord/views/bimbel_ricord_view.dart';
import '../modules/changePassword/bindings/change_password_binding.dart';
import '../modules/changePassword/views/change_password_view.dart';
import '../modules/commisionDetail/bindings/commision_detail_binding.dart';
import '../modules/commisionDetail/views/commision_detail_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/detailBimbel/bindings/detail_bimbel_binding.dart';
import '../modules/detailBimbel/views/detail_bimbel_view.dart';
import '../modules/detailMyBimbel/bindings/detail_my_bimbel_binding.dart';
import '../modules/detailMyBimbel/views/detail_my_bimbel_view.dart';
import '../modules/detail_event/bindings/detail_event_binding.dart';
import '../modules/detail_event/views/detail_event_view.dart';
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
import '../modules/mutasiSaldo/bindings/mutasi_saldo_binding.dart';
import '../modules/mutasiSaldo/views/mutasi_saldo_view.dart';
import '../modules/myAccount/bindings/my_account_binding.dart';
import '../modules/myAccount/views/my_account_view.dart';
import '../modules/myBimbel/bindings/my_bimbel_binding.dart';
import '../modules/myBimbel/views/my_bimbel_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/panduan_tryout/bindings/panduan_tryout_binding.dart';
import '../modules/panduan_tryout/views/panduan_tryout_view.dart';
import '../modules/paymentCheckout/bindings/payment_checkout_binding.dart';
import '../modules/paymentCheckout/views/payment_checkout_view.dart';
import '../modules/paymentDetail/bindings/payment_detail_binding.dart';
import '../modules/paymentDetail/views/payment_detail_view.dart';
import '../modules/pengerjaan_tryout/bindings/pengerjaan_tryout_binding.dart';
import '../modules/pengerjaan_tryout/views/pengerjaan_tryout_view.dart';
import '../modules/pretest/bindings/pretest_binding.dart';
import '../modules/pretest/views/pretest_view.dart';
import '../modules/pretestDetail/bindings/pretest_detail_binding.dart';
import '../modules/pretestDetail/views/pretest_detail_view.dart';
import '../modules/pretestRanking/bindings/pretest_ranking_binding.dart';
import '../modules/pretestRanking/views/pretest_ranking_view.dart';
import '../modules/pretestResult/bindings/pretest_result_binding.dart';
import '../modules/pretestResult/views/pretest_result_view.dart';
import '../modules/pretestTour/bindings/pretest_tour_binding.dart';
import '../modules/pretestTour/views/pretest_tour_view.dart';
import '../modules/programSaya/bindings/program_saya_binding.dart';
import '../modules/programSaya/views/program_saya_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/rekening/bindings/rekening_binding.dart';
import '../modules/rekening/views/rekening_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/tarikKomisi/bindings/tarik_komisi_binding.dart';
import '../modules/tarikKomisi/views/tarik_komisi_view.dart';
import '../modules/termConditons/bindings/term_conditons_binding.dart';
import '../modules/termConditons/views/term_conditons_view.dart';
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
import '../modules/wishlist/bindings/wishlist_binding.dart';
import '../modules/wishlist/views/wishlist_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

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
    GetPage(
      name: _Paths.PENGERJAAN_TRYOUT,
      page: () => const PengerjaanTryoutView(),
      binding: PengerjaanTryoutBinding(),
    ),
    GetPage(
      name: _Paths.REKENING,
      page: () => const RekeningView(),
      binding: RekeningBinding(),
    ),
    GetPage(
      name: _Paths.MUTASI_SALDO,
      page: () => const MutasiSaldoView(),
      binding: MutasiSaldoBinding(),
    ),
    GetPage(
      name: _Paths.TARIK_KOMISI,
      page: () => const TarikKomisiView(),
      binding: TarikKomisiBinding(),
    ),
    GetPage(
      name: _Paths.BIMBEL,
      page: () => const BimbelView(),
      binding: BimbelBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_BIMBEL,
      page: () => const DetailBimbelView(),
      binding: DetailBimbelBinding(),
    ),
    GetPage(
      name: _Paths.MY_BIMBEL,
      page: () => const MyBimbelView(),
      binding: MyBimbelBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MY_BIMBEL,
      page: () => const DetailMyBimbelView(),
      binding: DetailMyBimbelBinding(),
    ),
    GetPage(
      name: _Paths.PRETEST_RESULT,
      page: () => const PretestResultView(),
      binding: PretestResultBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_EVENT,
      page: () => const DetailEventView(),
      binding: DetailEventBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_DETAIL,
      page: () => const PaymentDetailView(),
      binding: PaymentDetailBinding(),
    ),
    GetPage(
      name: _Paths.PRETEST_RANKING,
      page: () => const PretestRankingView(),
      binding: PretestRankingBinding(),
    ),
    GetPage(
      name: _Paths.BIMBEL_RECORD,
      page: () => const BimbelRecordView(),
      binding: BimbelRecordBinding(),
    ),
    GetPage(
      name: _Paths.TERM_CONDITONS,
      page: () => const TermConditonsView(),
      binding: TermConditonsBinding(),
    ),
    GetPage(
      name: _Paths.PRETEST_DETAIL,
      page: () => const PretestDetailView(),
      binding: PretestDetailBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_CHECKOUT,
      page: () => const PaymentCheckoutView(),
      binding: PaymentCheckoutBinding(),
    ),
    GetPage(
      name: _Paths.PRETEST,
      page: () => const PretestView(),
      binding: PretestBinding(),
    ),
    GetPage(
      name: _Paths.PRETEST_TOUR,
      page: () => const PretestTourView(),
      binding: PretestTourBinding(),
    ),
  ];
}
