import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/cities_list.dart';
import '../models/city.dart';
import '../utils/time_helper.dart';
import '../widgets/city_card.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = "";
  bool _use24Hour = false;
  Set<String> _favorites = {};
  late Timer _timer;

  // New state for sorting and layout
  bool _isListView = false;
  bool _groupByContinent = false;
  String _deviceTimezone = "";

  @override
  void initState() {
    super.initState();
    _deviceTimezone = TimeHelper.getDeviceTimezone();
    _loadPrefs();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _use24Hour = prefs.getBool('use24Hour') ?? false;
      _favorites = (prefs.getStringList('favorites') ?? []).toSet();
      _isListView = prefs.getBool('isListView') ?? false;
      _groupByContinent = prefs.getBool('groupByContinent') ?? false;
    });
    _maybeShowOnboarding(prefs);
  }

  Future<void> _maybeShowOnboarding(SharedPreferences prefs) async {
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    if (hasSeenOnboarding) return;
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Welcome to Sky Clock"),
          content: Text(
            "Each city's background reflects the time of day there right now — morning, afternoon, evening, or night. It's based on local time, not live weather, so a sunny image can still show up even if it's actually raining there.\n\nTap the ⭐ to favorite a city (it moves to the top)${kIsWeb ? "." : ", or the widget icon to pin it to your home screen."}",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await prefs.setBool('hasSeenOnboarding', true);
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text("Got it"),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _toggle24Hour(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use24Hour', value);
    setState(() {
      _use24Hour = value;
    });
  }

  Future<void> _toggleFavorite(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favorites.contains(cityName)) {
        _favorites.remove(cityName);
      } else {
        _favorites.add(cityName);
      }
    });
    await prefs.setStringList('favorites', _favorites.toList());
  }

  Future<void> _toggleViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isListView = !_isListView;
    });
    await prefs.setBool('isListView', _isListView);
  }

  Future<void> _toggleGrouping() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _groupByContinent = !_groupByContinent;
    });
    await prefs.setBool('groupByContinent', _groupByContinent);
  }

  // Helper to get continent from timezone string (e.g., "Africa/Lagos" -> "Africa")
  String _getContinent(String timezone) {
    if (timezone.startsWith("Africa")) return "Africa";
    if (timezone.startsWith("America")) return "Americas";
    if (timezone.startsWith("Asia")) return "Asia";
    if (timezone.startsWith("Europe")) return "Europe";
    if (timezone.startsWith("Australia") || timezone.startsWith("Pacific")) {
      return "Oceania";
    }
    return "Other";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filter
    final filteredCities = cities.where((city) {
      final search = _query.toLowerCase();
      return city.name.toLowerCase().contains(search) ||
          city.country.toLowerCase().contains(search);
    }).toList();

    // 2. Sort (Favorites -> Closest City -> Alphabetical)
    filteredCities.sort((a, b) {
      final aFav = _favorites.contains(a.name);
      final bFav = _favorites.contains(b.name);
      if (aFav != bFav) return aFav ? -1 : 1;

      final aIsLocal = a.timezone == _deviceTimezone;
      final bIsLocal = b.timezone == _deviceTimezone;
      if (aIsLocal != bIsLocal) return aIsLocal ? -1 : 1;

      return a.name.compareTo(b.name);
    });

    // 3. Grouping
    final Map<String, List<City>> groupedCities = {};
    if (_groupByContinent) {
      for (final city in filteredCities) {
        final continent = _getContinent(city.timezone);
        groupedCities.putIfAbsent(continent, () => []).add(city);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sky Clock"),
        actions: [
          IconButton(
            icon: Icon(
              _groupByContinent ? Icons.folder_special : Icons.folder_open,
            ),
            tooltip: "Group by Continent",
            onPressed: _toggleGrouping,
          ),
          IconButton(
            icon: Icon(_isListView ? Icons.grid_view : Icons.view_list),
            tooltip: "Toggle Grid/List View",
            onPressed: _toggleViewMode,
          ),
          TextButton(
            onPressed: () => _toggle24Hour(!_use24Hour),
            child: Text(
              _use24Hour ? "24h" : "12h",
              style: TextStyle(
                color:
                    Theme.of(context).appBarTheme.foregroundColor ??
                    Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              widget.onThemeChanged(!isDark);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search city or country...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredCities.isEmpty
                ? _buildEmptyState(context)
                : _buildContent(context, filteredCities, groupedCities),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            "No cities match \"$_query\"",
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<City> flatList,
    Map<String, List<City>> grouped,
  ) {
    if (_groupByContinent) {
      return ListView(
        padding: const EdgeInsets.all(12),
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Text(
                  entry.key,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildCityLayout(entry.value),
            ],
          );
        }).toList(),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: _buildCityLayout(flatList),
    );
  }

  Widget _buildCityLayout(List<City> cityList) {
    if (_isListView) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cityList.length,
        itemBuilder: (context, index) {
          final city = cityList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CityCard(
              city: city,
              use24Hour: _use24Hour,
              isFavorite: _favorites.contains(city.name),
              onFavoriteToggle: () => _toggleFavorite(city.name),
              isListView: true,
            ),
          );
        },
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: cityList.length,
        itemBuilder: (context, index) {
          final city = cityList[index];
          return CityCard(
            city: city,
            use24Hour: _use24Hour,
            isFavorite: _favorites.contains(city.name),
            onFavoriteToggle: () => _toggleFavorite(city.name),
            isListView: false,
          );
        },
      );
    }
  }
}
