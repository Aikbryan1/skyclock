import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'screens/home_screen.dart';

void main() {
  tzdata.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sky Clock',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
