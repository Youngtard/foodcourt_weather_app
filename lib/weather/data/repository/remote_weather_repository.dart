import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodcourt_weather/weather/domain/models/weather_data.dart';

import '../../../core/dio_client.dart';
import '../../../core/endpoints.dart';

final remoteWeatherRepositoryProvider = Provider<RemoteWeatherRepository>((ref) {
  return RemoteWeatherRepository(ref.watch(dioProvider));
});

class RemoteWeatherRepository {
  const RemoteWeatherRepository(this._dio);

  final DioClient _dio;

  Future<WeatherData> fetchWeatherData({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get(
        Endpoints.weatherData,
        queryParams: {
          "lat": latitude,
          "lon": longitude,
          "appid": "21c3d26e6d586e2bd7fe55f6d675c76f",
          "units": "metric",
        },
      );

      return WeatherData.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
