import 'package:intl/intl.dart';

class DisplayUtil {

  static String dollarsFormatter(num amount) {
    return NumberFormat.simpleCurrency(decimalDigits: 0).format(amount);
  }

}