import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleAssetLoader extends AssetLoader {
  const LocaleAssetLoader({
    required Dio dio,
    required SharedPreferences preferences,
  }) : _dio = dio,
       _preferences = preferences;

  final Dio _dio;
  final SharedPreferences _preferences;

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final localeCode = '${locale.languageCode}-${locale.countryCode}';
    final cacheKey = 'translations_$localeCode';

    final cached = _preferences.getString(cacheKey);
    if (cached != null) {
      try {
        return Map<String, dynamic>.from(json.decode(cached));
      } catch (error) {
        debugPrint(
          'Failed to decode cached translations for $localeCode: $error',
        );
      }
    }

    final url = '$path/$localeCode.json';
    try {
      final response = await _dio.get<Map<String, dynamic>>(url);
      final data = response.data;
      if (response.statusCode == 200 && data != null) {
        final jsonString = json.encode(data);
        await _preferences.setString(cacheKey, jsonString);
        return Map<String, dynamic>.from(data);
      }
    } on DioException catch (e) {
      debugPrint('Dio fetch failed for $localeCode: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error loading $localeCode.json: $e');
    }

    if (cached != null) {
      try {
        return Map<String, dynamic>.from(json.decode(cached));
      } catch (_) {
        return {};
      }
    }

    return {};
  }
}
