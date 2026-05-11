import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/constants/enums/data_status.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/features/home/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_clean_architecture/features/home/domain/usecases/get_todo_usecase.dart';
import 'package:flutter_clean_architecture/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const todos = [
    Todo(id: 1, userId: 1, title: 'Render cubit state', completed: false),
  ];

  test('initial state is initial with no todos', () {
    final cubit = HomeCubit(
      GetTodoUseCase(_FakeHomeRepository(result: const Right(todos))),
    );

    expect(cubit.state, const HomeState());

    cubit.close();
  });

  test('emits loading then success when todos load', () async {
    final cubit = HomeCubit(
      GetTodoUseCase(_FakeHomeRepository(result: const Right(todos))),
    );

    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const HomeState(dataStatus: DataStatus.loading),
        const HomeState(dataStatus: DataStatus.success, todoList: todos),
      ]),
    );

    await cubit.getTodos();
    await expectation;
    await cubit.close();
  });

  test('emits loading then failure when loading fails', () async {
    final cubit = HomeCubit(
      GetTodoUseCase(
        _FakeHomeRepository(result: const Left(ServerFailure('No internet'))),
      ),
    );

    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const HomeState(dataStatus: DataStatus.loading),
        const HomeState(dataStatus: DataStatus.failure, error: 'No internet'),
      ]),
    );

    await cubit.getTodos();
    await expectation;
    await cubit.close();
  });
}

class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository({required this.result});

  final Either<Failure, List<Todo>> result;

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    return result;
  }
}
