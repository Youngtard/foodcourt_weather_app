import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:foodcourt_weather/utils/app_colors.dart';
import 'package:foodcourt_weather/utils/utils.dart';
import 'package:foodcourt_weather/weather/domain/models/city.dart';
import 'package:foodcourt_weather/weather/presentation/screens/components/carousel_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _sliders = cities
      .take(3)
      .mapIndexed(
        (index, city) => CarouselItem(
          index: index,
          title: city.name,
          degree: "34°",
          description: "Mostly cloudy",
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FoodCourt Weather",
          style: textTheme.headlineLarge,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.9,
                  padEnds: false,
                ),
                items: _sliders,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "Current Location",
                style: textTheme.bodyLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Toronto",
                    style: textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    children: [
                      Text(
                        "34°",
                        style: textTheme.headlineLarge!.copyWith(
                          fontSize: 48,
                        ),
                      ),
                      Text(
                        "Mostly cloudy",
                        style: textTheme.bodyLarge!.copyWith(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "Cities",
                style: textTheme.bodyLarge,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final city = cities[index];

                    return ListTile(
                      leading: Icon(
                        Icons.location_city_rounded,
                        color: kNeutral900.withOpacity(0.7),
                      ),
                      title: Text(
                        city.name,
                      ),
                      trailing: Text(
                        "Selected",
                        style: textTheme.bodySmall,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
