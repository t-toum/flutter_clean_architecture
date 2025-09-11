import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final int id;
  final int userId;
  final String title;
  final bool completed;

  const Todo({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  @override
  List<Object?> get props => [id, userId, title, completed];
}
