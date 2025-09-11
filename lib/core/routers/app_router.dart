// GoRouter configuration
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/DI/service_locator.dart';
import 'package:flutter_clean_architecture/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_clean_architecture/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: BlocProvider<HomeCubit>(
          create: (context) => getIt<HomeCubit>()..getTodos(),
          child: const HomePage(),
        )
      ),
    ),
  ],
);