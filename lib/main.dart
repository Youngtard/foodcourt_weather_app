import 'package:flutter/material.dart';
import 'package:foodcourt_weather/utils/app_theme.dart';
import 'package:foodcourt_weather/utils/utils.dart';
import 'package:foodcourt_weather/weather/presentation/screens/main_screen.dart';
import 'package:foodcourt_weather/weather/presentation/screens/select_cities_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodCourt Weather',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.light(),
      home: const SelectCitiesScreen(),
    );
  }
}
