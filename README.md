# Skyclock 🌍⏰

A beautiful world clock app that displays current time across different cities, with dynamic backgrounds based on the time of day.

## Features

- 🌍 View current time in multiple cities worldwide, searchable by city or country
- 🌅 Dynamic backgrounds (Morning/Afternoon/Evening/Night) matched to each city's real local time
- ⭐ Favorite cities — pin your most-checked cities to the top of the list
- 🌓 Light/dark mode toggle
- 🕐 12-hour / 24-hour time format toggle
- ⏱️ Live-updating clocks — times refresh automatically, no need to reload
- 📍 Tap any city for a full-screen detail view
- 🎨 Clean, modern UI with gradient overlays for readability
- 📱 Responsive design for mobile, web, and desktop

## Tech Stack

- Flutter
- Dart
- `timezone` package for accurate, DST-aware time calculations
- `shared_preferences` for saving favorites and settings locally

## Installation

### Android

Download the APK from [Releases](https://github.com/Aikbryan1/skyclock/releases)

### Web

Visit [https://aikbryan1.github.io/skyclock](https://aikbryan1.github.io/skyclock)

## Development

```bash
# Get dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Build APK
flutter build apk --release

# Build web (note the base-href, required for GitHub Pages)
flutter build web --release --base-href "/skyclock/"
```

## Project Structure

```
lib/
  main.dart              # App entry point, theme state
  models/city.dart        # City data shape
  data/cities_list.dart   # List of cities and their timezones
  utils/time_helper.dart  # Time/period calculation logic
  widgets/city_card.dart  # Individual city card UI
  screens/home_screen.dart    # Main grid, search, settings
  screens/detail_screen.dart  # Full-screen city view
```