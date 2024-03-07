import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodcourt_weather/weather/data/repository/remote_weather_repository.dart';
import 'package:foodcourt_weather/weather/domain/models/weather_data.dart';

final weatherServiceProvider = Provider<WeatherService>(
  (ref) => WeatherService(
    remoteCitiesRepository: ref.watch(remoteWeatherRepositoryProvider),
  ),
);

class WeatherService {
  WeatherService({
    required RemoteWeatherRepository remoteCitiesRepository,
  }) : _remoteCitiesRepository = remoteCitiesRepository;

  final RemoteWeatherRepository _remoteCitiesRepository;

  Future<WeatherData> fetchWeatherData({
    required double latitude,
    required double longitude,
  }) async {
    return await _remoteCitiesRepository.fetchWeatherData(
      latitude: latitude,
      longitude: longitude,
    );
  }
}
