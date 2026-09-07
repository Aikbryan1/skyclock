import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'screens/home_screen.dart';

void main() {
  tzdata.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Clock',
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: _themeMode,
      home: HomeScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}
