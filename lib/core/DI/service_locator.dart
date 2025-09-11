import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/DI/service_locator.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void>configureDependencies()async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize dependencies
  await getIt.init();
}