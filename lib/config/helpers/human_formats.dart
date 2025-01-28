import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number) {
    final formatterNumber = NumberFormat.compactCurrency(
      decimalDigits: 1,
      symbol: '',
      locale: 'en_US',
    ).format(number);

    return formatterNumber;
  }

  static String date(DateTime date) {
    final String formatterDate = DateFormat("EEEE, d").format(date);

    return formatterDate;
  }
}
