import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flutter_clean_architecture/features/home/data/models/todo_model.dart';
import 'package:flutter_clean_architecture/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_clean_architecture/features/home/domain/entities/todo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const todos = [
    TodoModel(id: 1, userId: 1, title: 'Map remote todos', completed: true),
  ];

  test('returns todos when the remote data source succeeds', () async {
    final dataSource = _FakeHomeRemoteDataSource(todos: todos);
    final repository = HomeRepositoryImpl(dataSource);

    final result = await repository.getTodos();

    result.fold(
      (failure) => fail('Expected todos but got $failure'),
      (items) => expect(items, const <Todo>[...todos]),
    );
  });

  test('maps ServerException to ServerFailure', () async {
    final dataSource = _FakeHomeRemoteDataSource(
      exception: const ServerException('Server unavailable'),
    );
    final repository = HomeRepositoryImpl(dataSource);

    final result = await repository.getTodos();

    result.fold(
      (failure) => expect(failure, const ServerFailure('Server unavailable')),
      (_) => fail('Expected failure but got todos'),
    );
  });

  test('maps unexpected errors to a generic ServerFailure', () async {
    final dataSource = _FakeHomeRemoteDataSource(
      exception: Exception('Invalid response'),
    );
    final repository = HomeRepositoryImpl(dataSource);

    final result = await repository.getTodos();

    result.fold(
      (failure) => expect(failure, const ServerFailure('Something went wrong')),
      (_) => fail('Expected failure but got todos'),
    );
  });
}

class _FakeHomeRemoteDataSource implements HomeRemoteDataSource {
  _FakeHomeRemoteDataSource({this.todos = const [], this.exception});

  final List<TodoModel> todos;
  final Object? exception;

  @override
  Future<List<TodoModel>> getTodos() async {
    final error = exception;
    if (error != null) {
      throw error;
    }

    return todos;
  }
}
