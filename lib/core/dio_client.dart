import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/constants.dart';
import 'endpoints.dart';
import 'exceptions.dart';

final dioProvider = Provider<DioClient>((ref) {
  return DioClient();
});

Future<Response> makeRequest(Future<Response> Function() f) async {
  try {
    final response = await f();

    return response;
  } on DioException catch (e) {
    if (e.type == DioExceptionType.badResponse) {
      if (e.response?.data != null) {
        final responseData = jsonDecode(jsonEncode(e.response!.data));

        String? responseMessage;

        if (responseData is Map) {
          responseMessage = responseData["message"];
        }

        if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
          throw NetworkFailure(kUnableToConnect, code: e.response?.statusCode);
        } else if (responseMessage != null) {
          throw NetworkFailure(responseMessage, code: e.response?.statusCode);
        } else {
          throw const NetworkFailure(kSomethingWentWrong, code: null);
        }
      } else {
        throw NetworkFailure(kUnableToConnect, code: e.response?.statusCode);
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      throw NetworkFailure(kUnableToConnect, code: e.response?.statusCode);
    } else if (e.error is SocketException) {
      throw NetworkFailure(kUnableToConnect, code: e.response?.statusCode);
    } else {
      throw NetworkFailure(kSomethingWentWrong, code: e.response?.statusCode);
    }
  } catch (e) {
    throw NetworkFailure(e.toString(), code: -1);
  }
}

class DioClient {
  final Dio dio = Dio()
    ..options.baseUrl = Endpoints.baseUrl
    ..options.contentType = "application/json"
    ..options.connectTimeout = const Duration(milliseconds: 30000)
    ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true)); //Log network requests

  DioClient();

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return makeRequest(() {
      return dio.get(
        url,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken,
      );
    });
  }
}
