import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:foodcourt_weather/utils/app_colors.dart';
import 'package:foodcourt_weather/utils/utils.dart';
import 'package:foodcourt_weather/weather/domain/models/city.dart';
import 'package:foodcourt_weather/weather/presentation/screens/main_screen.dart';

class SelectCitiesScreen extends StatefulWidget {
  const SelectCitiesScreen({super.key});

  @override
  State<SelectCitiesScreen> createState() => _SelectCitiesScreenState();
}

class _SelectCitiesScreenState extends State<SelectCitiesScreen> {
  final int _limit = 3;
  final List<City> _selectedCities = [];

  @override
  void initState() {
    super.initState();
    //Lagos selected by default
    _selectedCities.add(cities[0]);
  }

  int _getCitiesLeft() {
    return _limit - _selectedCities.length;
  }

  bool _enableButton() {
    return _selectedCities.length == _limit;
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
                        Visibility(
                          // visible: _selectedCities.length != _limit,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: Text(
                            _selectedCities.length != _limit
                                ? "Kindly select ${_getCitiesLeft()} more ${_getCitiesLeft() == 1 ? "city" : "cities"} to proceed"
                                : _selectedCities.map((e) => e.name).join(", "),
                            style: textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 72,
                        ),
                        Wrap(
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
                                      if (_selectedCities.length < _limit) {
                                        _selectedCities.add(city);
                                      }
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: isSelected ? kBlueColor : kNeutral900.withOpacity(0.5),
                                      ),
                                      color: isSelected ? kBlueColor : Colors.white,
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
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: _enableButton() ? kBlueColor : kBlueColor.withOpacity(0.6),
                ),
                onPressed: () {
                  if (_enableButton()) {
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
