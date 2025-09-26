import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Format angka jadi Rupiah
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

/// Hitung komisi detail
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

/// TextField otomatis uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Format tanggal dari "2025-09-26 11:15:07" ke "26 September 2025"
String formatTanggal(String? tanggalStr) {
  if (tanggalStr == null || tanggalStr.isEmpty) return "-";
  try {
    DateTime date = DateTime.parse(tanggalStr);
    return DateFormat("dd MMMM yyyy", "id_ID").format(date);
  } catch (e) {
    return tanggalStr; // fallback kalau gagal parse
  }
}
