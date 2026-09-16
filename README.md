# Skyclock 🌍⏰

A beautiful world clock app that displays the current time across different cities, with dynamic backgrounds that reflect the time of day in each city.

## Features

- 🌍 **View current time in multiple cities worldwide** — searchable by city or country
- 🌅 **Dynamic backgrounds** (Morning / Afternoon / Evening / Night) matched to each city's real local time
- ⭐ **Favorite cities** — pinned to the top of the list
- 📌 **Home screen widget** — pin any city to your Android home screen and see its time at a glance
- 🔲 **Grid or list view** — switch layouts to suit your screen
- 🗂️ **Group by continent** — organize cities by region
- 🌓 **Light / dark mode** toggle
- 🕐 **12-hour / 24-hour** time format toggle
- ⏱️ **Live-updating clocks** — times refresh automatically
- 📍 **Tap any city** for a full-screen detail view
- 🎨 Clean, modern UI with gradient overlays for readability
- 📱 Responsive design for mobile and web

## Tech Stack

- **Flutter** / **Dart**
- [`timezone`](https://pub.dev/packages/timezone) — accurate, DST-aware time calculations
- [`shared_preferences`](https://pub.dev/packages/shared_preferences) — saving favorites and settings locally
- [`home_widget`](https://pub.dev/packages/home_widget) — Android home screen widget integration

## Installation

### Android

Download the latest APK from [Releases](https://github.com/Aikbryan1/skyclock/releases).

### Web

Visit [https://aikbryan1.github.io/skyclock](https://aikbryan1.github.io/skyclock).

> **Windows / macOS / Linux:** The app is written cross-platform, but desktop builds require the corresponding toolchain (Visual Studio for Windows, Xcode for macOS). Native desktop releases are not currently published.

## Development

```bash
# Get dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on Android (device connected)
flutter run -d android

# Build release APK
flutter build apk --release

# Build for web (base-href is required for GitHub Pages)
flutter build web --release --base-href "/skyclock/"

#Project Structure
lib/
  main.dart                        # App entry point, theme state
  models/
    city.dart                      # City data shape
  data/
    cities_list.dart               # List of cities and their timezones
  utils/
    time_helper.dart               # Time / period calculation logic
    home_widget_helper.dart        # Android home-screen widget bridge
  widgets/
    city_card.dart                 # Individual city card UI (grid + list)
  screens/
    splash_screen.dart             # Splash screen
    home_screen.dart               # Main grid / list, search, settings
    detail_screen.dart             # Full-screen city view

android/app/src/main/
  kotlin/.../SkyClockWidgetProvider.kt   # Native widget provider
  res/layout/skyclock_widget.xml         # Widget layout
  res/xml/skyclock_widget_info.xml       # Widget metadata
  res/drawable/                          # Widget backgrounds (copies of assets)
