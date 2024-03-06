import 'package:flutter/material.dart';
import 'package:foodcourt_weather/utils/utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FoodCourt Weather",
          style: textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
    );
  }
}
