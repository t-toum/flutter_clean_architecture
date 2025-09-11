import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/constants/enums/data_status.dart';
import 'package:flutter_clean_architecture/features/home/presentation/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter clean architecture"),
        backgroundColor: Colors.blueAccent,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if(state.dataStatus == DataStatus.loading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(state.dataStatus == DataStatus.failure){
            return Center(
              child: Text(state.error ?? ""),
            );
          }
          return ListView.builder(
            itemCount: state.todoList.length,
            itemBuilder: (context, index){
              final todo = state.todoList[index];
              return ListTile(
                title: Text(todo.title),
                // subtitle: Text(todo.description),
              );
            },
          );
        },
      ),
    );
  }
}
