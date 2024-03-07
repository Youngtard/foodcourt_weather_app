import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodcourt_weather/weather/domain/models/city.dart';
import 'package:foodcourt_weather/weather/domain/models/weather_data.dart';

import '../../domain/service/weather_service.dart';

final weatherDataProvider = AutoDisposeNotifierProviderFamily<WeatherDataProvider, AsyncValue<WeatherData?>, City>(
  WeatherDataProvider.new,
);

class WeatherDataProvider extends AutoDisposeFamilyNotifier<AsyncValue<WeatherData?>, City> {
  @override
  AsyncValue<WeatherData?> build(arg) {
    return const AsyncData(null);
  }

  Future<void> fetchData({
    required double latitude,
    required double longitude,
  }) async {
    final weatherService = ref.watch(weatherServiceProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => weatherService.fetchWeatherData(
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }
}
