import 'package:intl/intl.dart';

class PriceFormatter {
  static String formatPrice(int price, {String? locale}) {
    final formatter = NumberFormat.currency(
      symbol: locale == 'ar' ? 'جنيه' : 'EGP',
      customPattern: '#,### ¤',
      locale: locale,
    );

    return formatter.format(price);
  }
}
