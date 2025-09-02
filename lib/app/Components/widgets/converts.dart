import 'package:intl/intl.dart';

String formatRupiah(num number) {
  final formatter = NumberFormat.currency(
    locale: 'id', // pakai format Indonesia
    symbol: 'Rp ', // kasih prefix Rp
    decimalDigits: 0, // tanpa desimal
  );
  return formatter.format(number);
}
