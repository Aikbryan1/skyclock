import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/cities_list.dart';
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

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCities = cities.where((city) {
      final search = _query.toLowerCase();
      return city.name.toLowerCase().contains(search) ||
          city.country.toLowerCase().contains(search);
    }).toList();

    // Favorites float to the top, everything else keeps its original order.
    filteredCities.sort((a, b) {
      final aFav = _favorites.contains(a.name);
      final bFav = _favorites.contains(b.name);
      if (aFav == bFav) return 0;
      return aFav ? -1 : 1;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sky Clock"),
        actions: [
          TextButton(
            onPressed: () => _toggle24Hour(!_use24Hour),
            child: Text(
              _use24Hour ? "24h" : "12h",
              style: TextStyle(
                color: Theme.of(context).appBarTheme.foregroundColor ??
                    Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => widget.onThemeChanged(!widget.isDarkMode),
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredCities.length,
              itemBuilder: (context, index) {
                final city = filteredCities[index];
                return CityCard(
                  city: city,
                  use24Hour: _use24Hour,
                  isFavorite: _favorites.contains(city.name),
                  onFavoriteToggle: () => _toggleFavorite(city.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
