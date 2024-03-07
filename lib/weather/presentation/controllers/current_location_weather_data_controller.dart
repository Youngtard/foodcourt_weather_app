import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/weather_data.dart';
import '../../domain/service/weather_service.dart';

final currentLocationWeatherDataProvider = AutoDisposeNotifierProvider<CurrentLocationWeatherDataProvider, AsyncValue<WeatherData?>>(
  CurrentLocationWeatherDataProvider.new,
);

class CurrentLocationWeatherDataProvider extends AutoDisposeNotifier<AsyncValue<WeatherData?>> {
  @override
  AsyncValue<WeatherData?> build() {
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
