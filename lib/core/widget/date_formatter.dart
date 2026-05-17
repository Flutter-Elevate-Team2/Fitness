// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

String formatDate(String dateStr, {String? locale}) {
  try {
    DateTime dateTime = DateTime.parse(dateStr);

    return DateFormat('d MMM yyyy', locale).format(dateTime);
  } catch (e) {
    return dateStr;
  }
}