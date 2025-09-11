import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/features/home/data/datasources/home_remote_datasource.dart';
import 'package:flutter_clean_architecture/features/home/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _homeRemoteDataSource;

  HomeRepositoryImpl(this._homeRemoteDataSource);

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final response = await _homeRemoteDataSource.getTodos();
      return Right(response);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }
}
