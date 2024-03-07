import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodcourt_weather/utils/app_colors.dart';
import 'package:foodcourt_weather/utils/utils.dart';
import 'package:foodcourt_weather/weather/data/repository/local_cities_repository.dart';
import 'package:foodcourt_weather/weather/domain/models/city.dart';
import 'package:foodcourt_weather/weather/presentation/controllers/current_location_weather_data_controller.dart';
import 'package:foodcourt_weather/weather/presentation/screens/components/carousel_item.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../utils/constants.dart';
import '../../domain/models/weather_data.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final _carouselController = CarouselController();

  late final LocalCitiesRepository _localCitiesProvider;

  late List<City> _selectedCities;
  late List<CarouselItem> _sliders;

  bool _gottenCurrentLocation = false;
  String? _currentLocation;

  final _carouselColors = [kPrimaryColor, kOrangeColor, kRedColor];

  String? _locationPermissionError;

  @override
  void initState() {
    super.initState();

    _getUserCurrentLocation();

    _localCitiesProvider = ref.read(localCitiesRepositoryProvider);

    _selectedCities = _localCitiesProvider.getCities() ?? [];
    _sliders = _getSliders();
  }

  Future<void> _getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationPermissionError = "Location services are disabled, kindly enable location services.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _locationPermissionError!,
          ),
        ),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationPermissionError = "Location permissions are denied, kindly allow location permissions.";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _locationPermissionError!,
            ),
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationPermissionError = "Location permissions are permanently denied, kindly allow location permissions.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _locationPermissionError!,
          ),
        ),
      );
      return;
    }

    setState(() {
      _locationPermissionError = null;
      _gottenCurrentLocation = false;
    });

    return await Geolocator.getCurrentPosition().then(
      (value) async {
        final lat = value.latitude;
        final long = value.longitude;

        placemarkFromCoordinates(value.latitude, value.longitude).then(
          (placeMarks) {
            if (placeMarks.isNotEmpty) {
              final placeMark = placeMarks[0];
              setState(() {
                _gottenCurrentLocation = true;
                _currentLocation = "${placeMark.street ?? ""}, ${placeMark.locality ?? kNotAvailable}";

                ref.read(currentLocationWeatherDataProvider.notifier).fetchData(
                      latitude: lat,
                      longitude: long,
                    );
              });
            }
          },
        );
      },
    );
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

  List<CarouselItem> _getSliders() {
    return _selectedCities
        .mapIndexed(
          (index, city) => CarouselItem(
            key: Key(city.toString()),
            index: index,
            bgColor: _carouselColors[_determineSliderColorIndex(index)],
            city: city,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<WeatherData?>>(
      currentLocationWeatherDataProvider,
      (_, state) => state.whenOrNull(
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error.toString(),
              ),
            ),
          );
        },
      ),
    );

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
                carouselController: _carouselController,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Current Location",
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  _gottenCurrentLocation || _locationPermissionError != null
                      ? IconButton(
                          onPressed: () {
                            _getUserCurrentLocation();
                          },
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: kNeutral900,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              _locationPermissionError != null
                  ? Text(
                      _locationPermissionError!,
                      style: textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: kNeutral900.withOpacity(0.6),
                      ),
                    )
                  : _gottenCurrentLocation
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                _currentLocation ?? kNotAvailable,
                                style: textTheme.headlineLarge!.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            ref.watch(currentLocationWeatherDataProvider).when(
                                  data: (data) {
                                    if (data != null) {
                                      final description = data.weather != null && data.weather!.isNotEmpty ? data.weather![0].description ?? "" : "";

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${data.main?.temp ?? kNotAvailable}°",
                                            style: textTheme.headlineLarge!.copyWith(
                                              fontSize: 48,
                                            ),
                                          ),
                                          Text(
                                            description.capitalize(),
                                            style: textTheme.bodyLarge,
                                          ),
                                          Text(
                                            "Feels like: ${data.main?.feelsLike ?? kNotAvailable}°",
                                            style: textTheme.bodyLarge,
                                          ),
                                        ],
                                      );
                                    }

                                    return const SizedBox();
                                  },
                                  error: (e, s) => const SizedBox(),
                                  loading: () => const FittedBox(
                                    child: SpinKitPulse(
                                      color: kNeutral900,
                                    ),
                                  ),
                                ),
                          ],
                        )
                      : const Center(
                          child: SpinKitWave(
                            color: kGreyColor,
                          ),
                        ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "Cities",
                style: textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 4,
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
                          : IconButton(
                              onPressed: () async {
                                if (isSelected) {
                                  _selectedCities.remove(city);
                                  setState(() {});
                                } else {
                                  _selectedCities.add(city);
                                }

                                await _localCitiesProvider.persistCities(_selectedCities);

                                _selectedCities = _localCitiesProvider.getCities() ?? [];
                                _sliders = _getSliders();

                                setState(() {});
                              },
                              icon: Text(
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
