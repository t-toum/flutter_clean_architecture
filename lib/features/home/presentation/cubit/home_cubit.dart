import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/constants/enums/data_status.dart';
import 'package:flutter_clean_architecture/core/extension/either_extension.dart';
import 'package:flutter_clean_architecture/core/usecases/no_params.dart';
import 'package:flutter_clean_architecture/features/home/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/home/domain/usecases/get_todo_usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'home_state.dart';

part 'home_cubit.freezed.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetTodoUseCase _getTodoUseCase;

  HomeCubit(this._getTodoUseCase) : super(const HomeState());

  Future<void> getTodos() async {
    emit(state.copyWith(dataStatus: DataStatus.loading));
    final result = await _getTodoUseCase(NoParams());
    if (result.isLeft()) {
      String error = result.getLeft().msg;
      emit(state.copyWith(dataStatus: DataStatus.failure, error: error));
    } else {
      emit(
        state.copyWith(
          dataStatus: DataStatus.success,
          todoList: result.getRight(),
        ),
      );
    }
  }
}
