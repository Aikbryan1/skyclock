import 'package:home_widget/home_widget.dart';
import 'time_helper.dart';
import '../models/city.dart';
import '../data/cities_list.dart';

/// Handles everything related to the Android home-screen widget:
/// saving the selected city, pushing fresh time data to it, and the
/// background callback that keeps it updating even when the app is closed.
class HomeWidgetHelper {
  static const String _androidWidgetName = 'SkyClockWidgetProvider';

  /// Call this once when the user picks a city to show on the widget
  /// (e.g. from a "Pin to widget" button on a CityCard).
  static Future<void> setWidgetCity(City city) async {
    await HomeWidget.saveWidgetData<String>('widget_city_key', city.timezone);
    await HomeWidget.saveWidgetData<String>(
      'widget_city_display_name',
      city.name,
    );
    await _refreshWidgetDisplay();
  }

  /// Recalculates the time/period for the saved city and pushes it to
  /// the native widget. Safe to call often — cheap, local calculation only.
  static Future<void> _refreshWidgetDisplay() async {
    final timezone = await HomeWidget.getWidgetData<String>('widget_city_key');
    final displayName = await HomeWidget.getWidgetData<String>(
      'widget_city_display_name',
    );
    if (timezone == null || displayName == null) return;

    final hour = TimeHelper.getHour(timezone);
    final period = TimeHelper.getPeriod(hour);
    final time = TimeHelper.getFormattedTime(timezone);

    await HomeWidget.saveWidgetData<String>('widget_city_name', displayName);
    await HomeWidget.saveWidgetData<String>('widget_time', time);
    await HomeWidget.saveWidgetData<String>('widget_period', period);

    await HomeWidget.updateWidget(
      name: _androidWidgetName,
      androidName: _androidWidgetName,
    );
  }

  /// Call this once from main() to refresh the widget every time the
  /// app is opened (covers the common case). The native 30-minute
  /// periodic update (set in skyclock_widget_info.xml) handles the
  /// rest while the app is closed.
  static Future<void> refreshOnAppOpen() async {
    await _refreshWidgetDisplay();
  }

  /// Ensures the widget has a default city set (user's device timezone,
  /// or Lagos as a final fallback) on first run.
  static Future<void> ensureDefaultWidgetCity() async {
    final existing = await HomeWidget.getWidgetData<String>('widget_city_key');
    if (existing != null && existing.isNotEmpty) return;

    // Fall back to the device's own timezone so the first-run widget
    // reflects where the user actually is.
    final deviceTz = TimeHelper.getDeviceTimezone();
    final match = cities.firstWhere(
      (c) => c.timezone == deviceTz,
      orElse: () => cities.firstWhere((c) => c.name == 'Lagos'),
    );
    await setWidgetCity(match);
  }
}
