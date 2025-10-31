import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/DI/service_locator.dart';
import 'package:flutter_clean_architecture/core/services/remote_asset_loader.dart';

import 'core/routers/app_router.dart';

void main() async {
  await configureDependencies();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('lo', 'LA')],
      path: 'https://ezlocalization.s3.ap-southeast-1.amazonaws.com/i18n',
      assetLoader: const LocaleAssetLoader(),
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
