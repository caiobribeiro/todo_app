import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/src/models/task.dart';
import 'package:todo_app/src/repository/board_repository.dart';
import 'package:todo_app/src/state/board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository repository;

  BoardCubit(this.repository) : super(EmptyBoardState());

  Future<void> fetchTasks() async {
    emit(LoadingBoardState());
    try {
      final tasks = await repository.fetch();
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  Future<void> addTask(Task newTask) async {
    final state = this.state;
    if (state is! GettedTaskBoardState) {
      return;
    }
    final tasks = state.tasks.toList();
    tasks.add(newTask);
    try {
      await repository.update(tasks);
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  Future<void> removeTask(Task task) async {
    final state = this.state;
    if (state is! GettedTaskBoardState) {
      return;
    }
    final tasks = state.tasks.toList();
    tasks.remove(task);
    try {
      await repository.update(tasks);
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  Future<void> checkTask(Task task) async {
    final state = this.state;
    if (state is! GettedTaskBoardState) {
      return;
    }
    final tasks = state.tasks.toList();
    final index = tasks.indexOf(task);
    tasks[index] = task.copyWith(check: !task.check);
    try {
      await repository.update(tasks);
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState(message: 'Error'));
    }
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTaskBoardState(tasks: tasks));
  }
}
