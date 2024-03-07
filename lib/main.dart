import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodcourt_weather/utils/app_theme.dart';
import 'package:foodcourt_weather/utils/hive_constants.dart';
import 'package:foodcourt_weather/utils/utils.dart';
import 'package:foodcourt_weather/weather/data/repository/local_cities_repository.dart';
import 'package:foodcourt_weather/weather/domain/models/city.dart';
import 'package:foodcourt_weather/weather/presentation/screens/main_screen.dart';
import 'package:foodcourt_weather/weather/presentation/screens/select_cities_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;

class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint('''
{
  "providers": "${provider.name ?? provider.runtimeType}",
  "previousValue": "$previousValue",
  "newValue": "$newValue"
}''');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Directory directory = await path.getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapter(CityAdapter());

  await Hive.openBox<List>(HiveConstants.citiesBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [
        ProviderLogger(),
      ],
      child: MaterialApp(
        title: 'FoodCourt Weather',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: AppTheme.light(),
        home: Consumer(
          builder: (context, ref, _) {
            final localCitiesProvider = ref.read(localCitiesRepositoryProvider);

            if ((localCitiesProvider.getCities() ?? []).isEmpty) {
              //Route user to select cities to display in carousel
              return const SelectCitiesScreen();
            }

            //User has already selected cities to display in carousel, route to main screen
            return const MainScreen();
          },
        ),
      ),
    );
  }
}
