import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/client/rest_client.dart';
import 'package:flutter_clean_architecture/core/errors/exceptions.dart';
import 'package:flutter_clean_architecture/features/home/data/models/todo_model.dart';
import 'package:injectable/injectable.dart';

abstract class HomeRemoteDataSource {
  Future<List<TodoModel>> getTodos();
}

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final RestClient _restClient;
  HomeRemoteDataSourceImpl(this._restClient);

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      final response = await _restClient.getTodos();
      return response;
    } on DioException catch (e) {
      throw ServerException(e.message ?? "Something went wrong");
    } catch (e) {
      debugPrint(e.toString());
      throw ServerException("Something went wrong");
    }
  }
}
