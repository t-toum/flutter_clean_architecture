import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/network/rest_client.dart';
import 'package:flutter_clean_architecture/core/services/remote_asset_loader.dart';
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
  @lazySingleton
  RestClient get client => RestClient(dio);

  @lazySingleton
  LocaleAssetLoader localeAssetLoader(Dio dio, SharedPreferences prefs) =>
      LocaleAssetLoader(dio: dio, preferences: prefs);
}
