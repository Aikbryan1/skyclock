import 'package:flutter/material.dart';
import '../models/city.dart';
import '../utils/time_helper.dart';
import '../utils/home_widget_helper.dart';
import '../screens/detail_screen.dart';

class CityCard extends StatelessWidget {
  final City city;
  final bool use24Hour;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final bool isListView; // Add this flag

  const CityCard({
    super.key,
    required this.city,
    required this.use24Hour,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.isListView = false, // Default to false (grid style)
  });

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
    final time = TimeHelper.getFormattedTime(
      city.timezone,
      use24Hour: use24Hour,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(city: city)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: isListView
            ? _buildListLayout(context, period, time)
            : _buildGridLayout(context, period, time),
      ),
    );
  }

  Widget _buildGridLayout(BuildContext context, String period, String time) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(_imageFor(period), fit: BoxFit.cover),
        _buildGradientOverlay(),
        Positioned(
          top: 12,
          left: 12,
          child: Text(
            period,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: Colors.white,
            ),
            onPressed: onFavoriteToggle,
          ),
        ),
        Positioned(
          top: 44,
          right: 4,
          child: IconButton(
            icon: const Icon(Icons.widgets_outlined, color: Colors.white),
            tooltip: "Set as home screen widget",
            onPressed: () async {
              await HomeWidgetHelper.setWidgetCity(city);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${city.name} pinned to widget")),
                );
              }
            },
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListLayout(BuildContext context, String period, String time) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_imageFor(period)),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          _buildGradientOverlay(isHorizontal: true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        city.name,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${city.country} • $period",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: onFavoriteToggle,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.widgets_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () async {
                            await HomeWidgetHelper.setWidgetCity(city);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${city.name} pinned to widget",
                                  ),
                                ),
                              );
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay({bool isHorizontal = false}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isHorizontal ? Alignment.centerLeft : Alignment.topCenter,
          end: isHorizontal ? Alignment.centerRight : Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: isHorizontal ? 0.7 : 0.0),
            Colors.black.withValues(alpha: isHorizontal ? 0.2 : 0.6),
          ],
          stops: isHorizontal ? const [0.0, 1.0] : const [0.5, 1.0],
        ),
      ),
    );
  }
}
