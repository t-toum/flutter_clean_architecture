import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/features/home/domain/entities/todo.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Todo>>> getTodos();
}
