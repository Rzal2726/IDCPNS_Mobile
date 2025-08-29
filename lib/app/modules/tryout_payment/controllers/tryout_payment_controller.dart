import 'package:get/get.dart';
import 'package:get_cli/common/utils/json_serialize/json_ast/parse.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/modules/detail_tryout/controllers/detail_tryout_controller.dart';
import 'package:intl/intl.dart';

class TryoutPaymentController extends GetxController {
  //TODO: Implement TryoutPaymentController

  final prevController = Get.find<DetailTryoutController>();

  RxMap<String, dynamic> selectedPaymentMethod = <String, dynamic>{}.obs;
  RxMap<String, dynamic> transactionData = <String, dynamic>{}.obs;
  RxList<int> itemsId = <int>[].obs;
  RxMap<String, bool> loading =
      <String, bool>{"other": false, "main": false, "bayar": false}.obs;

  RxString selectedPaymentType = "VIRTUAL_ACCOUNT".obs;
  RxList<Map<String, dynamic>> paymentMethods = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> selectedItems = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> otherTryout = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> virtualAccount = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> EWallet = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> QR = <Map<String, dynamic>>[].obs;
  RxMap<String, dynamic> dataTryout = <String, dynamic>{}.obs;
  RxString ovoNumber = "".obs;
  RxDouble diskon = 0.0.obs;
  RxString promoCode = "".obs;
  RxDouble totalHarga = 0.0.obs;
  RxDouble harga = 0.0.obs;
  RxDouble biayaAdmin = 0.0.obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    startInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> startInit() async {
    loading['bayar'] = true;
    await fetchDetailTryout();
    // await fetchDetailTryoutEvent();
    await fetchDetailTryoutOther();
    await fetchListPayment();
    loading['bayar'] = false;
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

  Future<void> fetchDetailTryout() async {
    try {
      final client = Get.find<RestClientProvider>();
      final response = await client.get(
        headers: {
          "Authorization":
              "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
        },
        '/tryout/formasi/${prevController.selectedUUid.value}',
      );

      if (response.statusCode == 200) {
        print(response.body);
        print("uuid : ${prevController.selectedUUid.value}");
        final Map<String, dynamic> paket = Map<String, dynamic>.from(
          response.body['data'],
        );
        dataTryout.assignAll(paket);
        selectedItems.add(paket);
        harga.value += paket['harga_fix'];
        initHarga();
      } else {
        print('Error: ${response.statusText}');
      }
    } catch (e) {
    } finally {}
  }

  Future<void> fetchDetailTryoutEvent() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/event/${prevController.selectedUUid.value}',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> fetchDetailTryoutOther() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.post(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/other-formasi',
      {},
    );

    if (response.statusCode == 200) {
      otherTryout.assignAll(
        List<Map<String, dynamic>>.from(response.body['data']),
      );
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> fetchListPayment() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/transaction/payment-type/list',
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response.body['data'],
      );
      paymentMethods.assignAll(data);
      await loadPaymentMethod(data);

      print("Payment");
      print('Data: ${response.body}');
      print('Data: ${virtualAccount}');
      print('Data: ${EWallet}');
      print('Data: ${QR}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> loadPaymentMethod(List data) async {
    // ambil list "data"

    // cari item dengan code = VIRTUAL_ACCOUNT
    final vaData = data.firstWhere(
      (e) => e['code'] == 'VIRTUAL_ACCOUNT',
      orElse: () => <String, dynamic>{},
    );
    final eData = data.firstWhere(
      (e) => e['code'] == 'EWALLET',
      orElse: () => <String, dynamic>{},
    );
    final qData = data.firstWhere(
      (e) => e['code'] == 'QR_CODE',
      orElse: () => <String, dynamic>{},
    );

    if (vaData != null) {
      final List vaList = vaData['xendit_payment_method'];

      // assign ke RxList<Map>
      virtualAccount.assignAll(
        vaList.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)),
      );
    }
    if (eData != null) {
      final List vaList = eData['xendit_payment_method'];

      // assign ke RxList<Map>
      EWallet.assignAll(
        vaList.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)),
      );
    }
    if (qData != null) {
      final List vaList = qData['xendit_payment_method'];

      // assign ke RxList<Map>
      QR.assignAll(
        vaList.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)),
      );
    }
  }

  String? getPaymentCategoryByCode(
    List<Map<String, dynamic>> data,
    String code,
  ) {
    for (final category in data) {
      final methods = category['xendit_payment_method'] as List;
      for (final method in methods) {
        if (method['code'] == code) {
          print(category['code']);
          return category['code']; // misalnya "VIRTUAL_ACCOUNT"
        }
      }
    }
    print("No Data");
    return null; // kalau tidak ketemu
  }

  void applyCode(String code) async {
    final client = Get.find<RestClientProvider>();
    final response = await client.post(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/voucher/apply',
      {"kode_promo": code, "amount": "100000"},
    );

    if (response.statusCode == 200) {
      diskon.value = double.parse(response.body['data']['nominal'].toString());
      promoCode.value = code;
      initHarga();
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void createPayment() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.post(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/transaction/create-payment',
      {
        "type": "tryout",
        "total_amount": totalHarga.value,
        "amount_diskon": diskon.value,
        "description": dataTryout['formasi'],
        "bundling": true,
        "tryout_formasi_id": dataTryout['id'],
        "kode_promo": promoCode.value,
        "items": itemsId,
        "source": "",
        "useBalance": false,
        "payment_method_id": selectedPaymentMethod['id'],
        "payment_method": selectedPaymentMethod['code'],
        "payment_type": selectedPaymentType.value,
        "mobile_number": ovoNumber.value,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        response.body['data'],
      );
      transactionData.assignAll(data);
      print('Data: ${response.body}');
      Get.toNamed("/tryout-checkout");
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void countAdmin() {
    try {
      final raw =
          (selectedPaymentMethod['biaya_admin'] ?? "").toString().trim();
      final paymentTypeId = selectedPaymentMethod['xendit_payment_type_id'];

      if (paymentTypeId == 1) {
        final clean = raw.replaceAll(
          RegExp(r'[^0-9]'),
          "",
        ); // buang titik, Rp, dsb.
        biayaAdmin.value = double.tryParse(clean) ?? 0;
      } else {
        // percentage (contoh: "2.7%")
        final clean = raw.replaceAll("%", "").trim();
        final persen = double.tryParse(clean) ?? 0;
        biayaAdmin.value = totalHarga.value.toDouble() * (persen / 100);
      }
    } catch (e, stack) {
      print(e);
      print(stack);
    }
  }

  void addTryout(Map<String, dynamic> data) {
    selectedItems.add(data);
    harga.value += data['harga_fix'];
    itemsId.add(data['id']);
    initHarga();
  }

  void removeTryout(Map<String, dynamic> data) {
    selectedItems.removeWhere((item) => item['id'] == data['id']);
    harga.value -= data['harga_fix'];
    itemsId.remove(data['id']);
    initHarga();
  }

  void initHarga() {
    totalHarga.value = (biayaAdmin.value + harga.value - diskon.value);
  }
}
