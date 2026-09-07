import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class TimeHelper {
  static int getHour(String timezoneName) {
    final location = tz.getLocation(timezoneName);
    final now = tz.TZDateTime.now(location);
    return now.hour;
  }

  static String getFormattedTime(String timezoneName, {bool use24Hour = false}) {
    final location = tz.getLocation(timezoneName);
    final now = tz.TZDateTime.now(location);
    return DateFormat(use24Hour ? 'HH:mm' : 'h:mm a').format(now);
  }

  static String getPeriod(int hour) {
    if (hour >= 5 && hour < 12) return "Morning";
    if (hour >= 12 && hour < 17) return "Afternoon";
    if (hour >= 17 && hour < 20) return "Evening";
    return "Night";
  }
}
