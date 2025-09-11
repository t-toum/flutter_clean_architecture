import 'package:flutter_clean_architecture/features/home/domain/entities/todo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);
}
