import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/core/usecases/no_params.dart';
import 'package:flutter_clean_architecture/features/home/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_clean_architecture/features/home/domain/usecases/get_todo_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const todos = [
    Todo(id: 1, userId: 1, title: 'Learn testing', completed: false),
  ];

  test('returns todos from the repository', () async {
    final repository = _FakeHomeRepository(result: const Right(todos));
    final useCase = GetTodoUseCase(repository);

    final result = await useCase(NoParams());

    expect(result, const Right<Failure, List<Todo>>(todos));
    expect(repository.getTodosCallCount, 1);
  });

  test('returns failure from the repository', () async {
    final failure = ServerFailure('Request failed');
    final repository = _FakeHomeRepository(result: Left(failure));
    final useCase = GetTodoUseCase(repository);

    final result = await useCase(NoParams());

    expect(result, Left<Failure, List<Todo>>(failure));
    expect(repository.getTodosCallCount, 1);
  });
}

class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository({required this.result});

  final Either<Failure, List<Todo>> result;
  int getTodosCallCount = 0;

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    getTodosCallCount++;
    return result;
  }
}
