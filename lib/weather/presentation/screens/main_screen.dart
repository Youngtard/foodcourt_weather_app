import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodcourt_weather/utils/app_colors.dart';
import 'package:foodcourt_weather/utils/utils.dart';
import 'package:foodcourt_weather/weather/data/repository/local_cities_repository.dart';
import 'package:foodcourt_weather/weather/domain/models/city.dart';
import 'package:foodcourt_weather/weather/presentation/screens/components/carousel_item.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late final LocalCitiesRepository _localCitiesProvider;

  late List<City> _selectedCities;
  late List<CarouselItem> _sliders;

  @override
  void initState() {
    super.initState();

    _localCitiesProvider = ref.read(localCitiesRepositoryProvider);

    _selectedCities = _localCitiesProvider.getCities() ?? [];
    _sliders = _getSliders();
  }

  int _determineSliderColorIndex(int index) {
    index = index + 1;

    if (index % 3 == 1) {
      return 0;
    } else if (index % 3 == 2) {
      return 1;
    } else {
      return 2;
    }
  }

  final _colors = [kPrimaryColor, kOrangeColor, kRedColor];

  List<CarouselItem> _getSliders() {
    return _selectedCities
        .mapIndexed(
          (index, city) => CarouselItem(
            index: index,
            bgColor: _colors[_determineSliderColorIndex(index)],
            city: city,
          ),
        )
        .toList();
  }

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
                  aspectRatio: 16 / 10,
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

                    final isSelected = _selectedCities.contains(city);

                    return ListTile(
                      leading: Icon(
                        Icons.location_city_rounded,
                        color: kNeutral900.withOpacity(0.7),
                      ),
                      title: Text(
                        city.name,
                      ),
                      trailing: city.name == "Lagos"
                          ? null
                          : InkWell(
                              onTap: () async {
                                if (isSelected) {
                                  _selectedCities.remove(city);
                                } else {
                                  _selectedCities.add(city);
                                }

                                await _localCitiesProvider.persistCities(_selectedCities);

                                _selectedCities = _localCitiesProvider.getCities() ?? [];
                                _sliders = _getSliders();

                                setState(() {});
                              },
                              child: Text(
                                isSelected ? "Unselect" : "Select",
                                style: textTheme.bodySmall!.copyWith(
                                  color: isSelected ? kNeutral900 : kPrimaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
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
