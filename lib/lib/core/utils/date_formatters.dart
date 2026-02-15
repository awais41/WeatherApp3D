import 'package:intl/intl.dart';

class DateFormatters {
  static String fullDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  static String dayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String hourLabel(DateTime date) {
    return DateFormat('HH.mm').format(date);
  }

  static String timeOfDay(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
