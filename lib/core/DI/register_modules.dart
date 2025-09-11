import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/client/rest_client.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class InjectionModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Dio get dio => Dio(
    BaseOptions(
      // baseUrl: const String.fromEnvironment(
      //   'API_BASE_URL',
      //   defaultValue: 'https://jsonplaceholder.typicode.com',
      // ),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );
  // Dio dio(SharedPreferences prefs) {
  //   final d = Dio(
  //     BaseOptions(
  //       baseUrl: const String.fromEnvironment(
  //         'API_BASE_URL',
  //         defaultValue: 'https://api.example.com',
  //       ),
  //       connectTimeout: const Duration(seconds: 10),
  //       receiveTimeout: const Duration(seconds: 20),
  //       headers: {'Accept': 'application/json'},
  //     ),
  //   );

  //   // Example interceptors: auth header + logging
  //   d.interceptors.addAll([
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) {
  //         final token = prefs.getString('access_token');
  //         if (token != null) {
  //           options.headers['Authorization'] = 'Bearer $token';
  //         }
  //         handler.next(options);
  //       },
  //     ),
  //     LogInterceptor(requestBody: true, responseBody: true),
  //   ]);

  //   return d;
  // }

  @lazySingleton
  RestClient get client => RestClient(dio);
}
