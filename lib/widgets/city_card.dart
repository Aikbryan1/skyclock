import 'package:flutter/material.dart';
import '../models/city.dart';
import '../utils/time_helper.dart';
import '../screens/detail_screen.dart';

class CityCard extends StatelessWidget {
  final City city;
  const CityCard({super.key, required this.city});

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

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(city: city)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit
              .expand, // forces every child below to fill the whole card
          children: [
            Image.asset(_imageFor(period), fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    city.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    city.country,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  Text(
                    period,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
