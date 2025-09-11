import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/features/home/data/models/todo_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../constants/api_path.dart';
part 'rest_client.g.dart';

@RestApi(baseUrl: APIPath.baseUrl)
abstract class RestClient {
  @factoryMethod
  factory RestClient(Dio dio) = _RestClient;

  @GET("/todos")
  Future<List<TodoModel>> getTodos();

}