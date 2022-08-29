library number_symbol_data;

import 'package:intl/number_symbols_data.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/intl.dart';

class CustomCurrencyFormatter {
  static NumberFormat getFormatter(
      {required String countryCode, bool short = false}) {
    String locale = numberFormatSymbols.values
        .firstWhere((element) => element.DEF_CURRENCY_CODE == countryCode)
        .NAME;
    if (short) {
      return NumberFormat.compactSimpleCurrency(
        locale: locale,
      );
    }
    return NumberFormat.simpleCurrency(
      locale: locale,
    );
  }
}
