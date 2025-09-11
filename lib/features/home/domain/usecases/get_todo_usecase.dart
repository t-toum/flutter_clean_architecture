import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/core/usecases/no_params.dart';
import 'package:flutter_clean_architecture/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture/features/home/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetTodoUseCase implements UseCase<List<Todo>, NoParams> {
  final HomeRepository _homeRepository;

  GetTodoUseCase(this._homeRepository);
  @override
  Future<Either<Failure, List<Todo>>> call(NoParams params) async {
    return await _homeRepository.getTodos();
  }
}
