import 'package:flutter/material.dart';
import '../data/cities_list.dart';
import '../widgets/city_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = "";

  @override
  Widget build(BuildContext context) {
    final filteredCities = cities.where((city) {
      final search = _query.toLowerCase();
      return city.name.toLowerCase().contains(search) ||
          city.country.toLowerCase().contains(search);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Sky Clock")),
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
                return CityCard(city: filteredCities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
