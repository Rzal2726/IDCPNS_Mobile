import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TryoutPaymentController extends GetxController {
  //TODO: Implement TryoutPaymentController

  RxMap<String, Map<String, dynamic>> paymentMethods =
      {
        "MANDIRI": {
          "image": "https://idcpns.com/img/payment-method/mandiri.svg",
        },
        "BCA": {"image": "https://idcpns.com/img/payment-method/bca.svg"},
        "BNI": {"image": "https://idcpns.com/img/payment-method/bni.svg"},
        "OVO": {"image": "https://idcpns.com/img/payment-method/ovo.svg"},
        "DANA": {"image": "https://idcpns.com/img/payment-method/dana.svg"},
        "QRIS": {"image": "https://idcpns.com/img/payment-method/qris.svg"},
      }.obs;
  RxString selectedPaymentMethod = "".obs;
  RxList<Map<dynamic, dynamic>> otherTryout =
      <Map<dynamic, dynamic>>[
        {"judul": "Other Tryout", "harga": "100000"},
        {
          "judul": "Paket Tryout BUMN Bahasa Inggris & Learning Agility",
          "harga": "100000",
        },
      ].obs;
  RxString promoCode = "".obs;
  RxInt totalHarga = 0.obs;
  RxInt harga = 0.obs;
  RxInt biayaAdmin = 0.obs;
  final count = 0.obs;
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

  String formatCurrency(dynamic number) {
    var customFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp.',
      decimalDigits: 0,
    );
    var formattedValue = customFormatter.format(int.parse(number));
    return formattedValue.toString();
  }

  void initHarga() {
    totalHarga.value = biayaAdmin.value + harga.value;
  }
}
