import 'package:flutter/material.dart';
import '../models/city.dart';
import '../utils/time_helper.dart';

class DetailScreen extends StatelessWidget {
  final City city;
  const DetailScreen({super.key, required this.city});

  String _imageFor(String period) {
    switch (period) {
      case "Morning":
        return "assets/morning.jpg";
      case "Afternoon":
        return "assets/afternoon.jpg";
      case "Evening":
        return "assets/evening.jpg";
      default:
        return "assets/night.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    final hour = TimeHelper.getHour(city.timezone);
    final period = TimeHelper.getPeriod(hour);
    final time = TimeHelper.getFormattedTime(city.timezone);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(_imageFor(period), fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        city.country,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 56,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        period,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
