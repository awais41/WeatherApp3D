import 'package:intl/intl.dart';

class TimeFormatter {
  const TimeFormatter._();

  static String formatAmPm(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
}
