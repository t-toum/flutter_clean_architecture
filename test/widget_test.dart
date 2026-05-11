import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/features/home/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_clean_architecture/features/home/domain/usecases/get_todo_usecase.dart';
import 'package:flutter_clean_architecture/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_clean_architecture/features/home/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('shows fetched todos on the home page', (tester) async {
    final repository = _FakeHomeRepository(
      todos: const [
        Todo(
          id: 1,
          userId: 1,
          title: 'Write cleaner Flutter tests',
          completed: false,
        ),
      ],
    );
    final cubit = HomeCubit(GetTodoUseCase(repository))..getTodos();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US')],
        path: 'unused',
        assetLoader: const _TestAssetLoader(),
        fallbackLocale: const Locale('en', 'US'),
        child: MaterialApp(
          home: BlocProvider<HomeCubit>.value(
            value: cubit,
            child: const HomePage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('hello'), findsOneWidget);
    expect(find.text('Write cleaner Flutter tests'), findsOneWidget);

    await cubit.close();
  });
}

class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository({required this.todos});

  final List<Todo> todos;

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    return Right(todos);
  }
}

class _TestAssetLoader extends AssetLoader {
  const _TestAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {'hello': 'Hello'};
  }
}
