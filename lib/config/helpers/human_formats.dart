import 'package:intl/intl.dart';

class HumanFormats {
  static String humanReadbleNumber(double number) {
    // Forzamos el uso del locale 'en' para asegurar las abreviaturas K, M, etc.
    final formatter = NumberFormat.compactCurrency(
      locale: 'en', // Asegura que use el formato en inglés
      decimalDigits: 1,
      symbol: '', // Sin símbolo de moneda
    );
    return formatter.format(number);
  }
}
