import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class TimeHelper {
  // Returns the current hour (0-23) for a given timezone name.
  static int getHour(String timezoneName) {
    final location = tz.getLocation(timezoneName);
    final now = tz.TZDateTime.now(location);
    return now.hour;
  }

  // Returns a formatted time string like "3:45 PM" for a given timezone.
  static String getFormattedTime(String timezoneName) {
    final location = tz.getLocation(timezoneName);
    final now = tz.TZDateTime.now(location);
    return DateFormat('h:mm a').format(now);
  }

  // Decides the period of day from the hour.
  static String getPeriod(int hour) {
    if (hour >= 5 && hour < 12) return "Morning";
    if (hour >= 12 && hour < 17) return "Afternoon";
    if (hour >= 17 && hour < 20) return "Evening";
    return "Night";
  }
}
