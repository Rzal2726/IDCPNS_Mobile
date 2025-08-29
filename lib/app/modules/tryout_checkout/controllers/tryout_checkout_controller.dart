import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/modules/tryout_payment/controllers/tryout_payment_controller.dart';
import 'package:intl/intl.dart';

class TryoutCheckoutController extends GetxController {
  //TODO: Implement TryoutCheckoutController
  final prevController = Get.find<TryoutPaymentController>();
  final client = Get.find<RestClientProvider>();

  RxMap<String, dynamic> transactionData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> paymentDetails = <String, dynamic>{}.obs;
  RxList<String> option = ["ATM", "MBanking"].obs;
  RxString selectedOption = "ATM".obs;
  RxString timeStamp = "".obs;
  RxBool isDeveloper = false.obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    initPayment();
    fetchServerTime();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initPayment() async {
    fetchDetailPayment();
  }

  void fetchDetailPayment() async {
    // transactionData.assignAll(prevController.transactionData);
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/transaction/payment-history/${prevController.transactionData['payment_id']}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        response.body['data'],
      );
      if (data['user']['level']['id'] == 3) {
        isDeveloper.value = true;
      }
      paymentDetails.assignAll(data);
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void fetchServerTime() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/general/server-time',
    );

    if (response.statusCode == 200) {
      int timestampInMilliseconds =
          response.body['data']; // Example timestamp in milliseconds
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        timestampInMilliseconds * 1000 + (86400 * 1000),
      );
      timeStamp.value = dateTime.toString();
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void simulatePayment() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.post(
      '/transaction/simulate',
      {"payment_id": paymentDetails['payment_id']},
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
      Get.offNamed("/pembayaran-berhasil");
    } else {
      print('Error: ${response.statusText}');
    }
  }

  String formatCurrency(dynamic number) {
    var customFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp.',
      decimalDigits: 0,
    );

    // ambil hanya digit, titik, koma
    final clean = number.toString().replaceAll(RegExp(r'[^0-9.,]'), "");

    // ganti koma dengan titik biar konsisten
    final normalized = clean.replaceAll(",", ".");

    final parsed = double.tryParse(normalized) ?? 0;

    return customFormatter.format(parsed);
  }
}
