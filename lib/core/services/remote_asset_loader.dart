
import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleAssetLoader extends AssetLoader {
  const LocaleAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = '${locale.languageCode}-${locale.countryCode}';
    final cacheKey = 'translations_$localeCode';

    // Check for cached version
    final cached = prefs.getString(cacheKey);
    if (cached != null) {
      try {
        return json.decode(cached);
      } catch (_) {}
    }

    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      responseType: ResponseType.json,
      headers: {'Accept': 'application/json'},
    ));

    final url = '$path/$localeCode.json';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200 && response.data != null) {
        // Store in cache
        final jsonString = json.encode(response.data);
        await prefs.setString(cacheKey, jsonString);
        return Map<String, dynamic>.from(response.data);
      }
    } on DioException catch (e) {
      print('⚠️ Dio fetch failed for $localeCode: ${e.message}');
    } catch (e) {
      print('❌ Unexpected error loading $localeCode.json: $e');
    }

    // Fallback to cached version if available
    return cached != null ? json.decode(cached) : {};
  }
}
