import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodcourt_weather/utils/app_colors.dart';
import 'package:foodcourt_weather/utils/utils.dart';
import 'package:foodcourt_weather/weather/data/repository/local_cities_repository.dart';
import 'package:foodcourt_weather/weather/domain/models/city.dart';
import 'package:foodcourt_weather/weather/presentation/screens/main_screen.dart';

class SelectCitiesScreen extends StatefulWidget {
  const SelectCitiesScreen({super.key});

  @override
  State<SelectCitiesScreen> createState() => _SelectCitiesScreenState();
}

class _SelectCitiesScreenState extends State<SelectCitiesScreen> {
  final int _minimumCities = 3;
  final List<City> _selectedCities = [];

  @override
  void initState() {
    super.initState();

    for (var city in cities) {
      if (city.name == "Lagos") {
        //Lagos selected by default
        _selectedCities.add(city);

        break;
      }
    }
  }

  int _getCitiesLeft() {
    return _minimumCities - _selectedCities.length;
  }

  bool _enableButton() {
    return _selectedCities.length >= _minimumCities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
            horizontal: 24,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 54,
                        ),
                        Text(
                          "Cities",
                          style: textTheme.headlineLarge,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          _selectedCities.length < _minimumCities
                              ? "Select at least ${_getCitiesLeft()} more ${_getCitiesLeft() == 1 ? "city" : "cities"} to proceed"
                              : _selectedCities.map((e) => e.name).join(", "),
                          style: textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Lagos is selected by default",
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: kNeutral900.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(
                          height: 72,
                        ),
                        Center(
                          child: Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            children: cities.mapIndexed(
                              (index, city) {
                                final isSelected = _selectedCities.contains(city);

                                return SingleChildScrollView(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      if (isSelected) {
                                        if (city.name != "Lagos") {
                                          _selectedCities.remove(city);
                                        }
                                      } else {
                                        _selectedCities.add(city);
                                      }
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(
                                          color: isSelected ? kPrimaryColor : kNeutral900.withOpacity(0.5),
                                        ),
                                        color: isSelected ? kPrimaryColor : Colors.white,
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              city.name,
                                              style: textTheme.bodyMedium!.copyWith(
                                                color: isSelected ? Colors.white : kNeutral900,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Icon(
                                            isSelected ? Icons.check : Icons.add,
                                            color: isSelected ? kNeutral900.withOpacity(0.8) : null,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Consumer(
                builder: (context, ref, _) {
                  final localCitiesProvider = ref.read(localCitiesRepositoryProvider);

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: _enableButton() ? kPrimaryColor : kPrimaryColor.withOpacity(0.6),
                    ),
                    onPressed: () async {
                      if (_enableButton()) {
                        try {
                          await localCitiesProvider.persistCities(_selectedCities);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString(),
                              ),
                            ),
                          );
                        }

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: Text(
                      "Proceed",
                      style: textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
