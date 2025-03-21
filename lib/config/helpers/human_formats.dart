import 'package:intl/intl.dart';

class HumanFormats {
  static String humanReadbleNumber(double number) {
    return NumberFormat.compactCurrency(
      decimalDigits: 1,
      symbol: '',
    ).format(number);
  }
}
