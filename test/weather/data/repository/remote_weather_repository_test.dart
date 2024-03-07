import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import '../../../fixtures/fixture_reader.dart';

void main() async {
  late Dio dio;
  late DioAdapter dioAdapter;

  Response<dynamic> response;

  group(
    'Weather data',
    () {
      const baseUrl = "https://api.openweathermap.org/data/2.5";

      setUp(() {
        dio = Dio(BaseOptions(baseUrl: baseUrl));
        dioAdapter = DioAdapter(
          dio: dio,
          matcher: const FullHttpRequestMatcher(),
        );

        dio.httpClientAdapter = dioAdapter;
      });

      test(
        "Fetch weather data",
        () async {
          const route = "/weather";

          final Map<String, dynamic> queryParams = {
            "lat": "1",
            "lon": "2",
            "appid": "asdfg;lkj",
            "units": "metric",
          };
          final Map<String, dynamic> responseData = jsonDecode(fixture("weather_data.json"));

          dioAdapter
            ..onGet(
              route,
              (server) => server.throws(
                400,
                DioException(
                  requestOptions: RequestOptions(
                    path: route,
                  ),
                ),
              ),
            )
            ..onGet(
              route,
              queryParameters: queryParams,
              (server) => server.reply(
                200,
                responseData,
                delay: const Duration(seconds: 1),
              ),
            );

          // Throws when to query parameters passed
          expect(
            () async => await dio.get(route),
            throwsA(isA<DioException>()),
          );

          response = await dio.get(
            route,
            queryParameters: queryParams,
          );

          expect(response.statusCode, 200);
        },
      );
    },
  );
}
