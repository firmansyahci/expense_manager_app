import 'package:intl/intl.dart';

class CommonUtil {
  static String toDateFormat(DateTime date) {
    final df = DateFormat('dd/MM/yyyy');
    return df.format(date);
  }

  static String toCurrencyFormat(double amount) {
    final nf = NumberFormat('#,##0', 'en_US');
    return 'Rp ' + nf.format(amount);
  }
}
