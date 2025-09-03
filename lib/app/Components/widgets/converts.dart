import 'package:intl/intl.dart';

String formatRupiah(dynamic value) {
  num number;

  if (value == null) {
    number = 0;
  } else if (value is num) {
    number = value;
  } else if (value is String) {
    number = num.tryParse(value) ?? 0;
  } else {
    throw ArgumentError('Tipe data tidak didukung: ${value.runtimeType}');
  }

  final formatter = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  return formatter.format(number);
}

int hitungKomisiDetail({
  required int amount,
  required int amountAdmin,
  required int amountDiskon,
  required int persen,
}) {
  // (amount + amount_diskon - amount_admin) * persen / 100
  final total = (amount + amountDiskon - amountAdmin);
  final hasil = total * persen ~/ 100; // ~/ biar hasilnya int langsung
  return hasil;
}
