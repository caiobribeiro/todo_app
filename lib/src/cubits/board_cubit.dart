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
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.add(newTask);
    await emitTasks(tasks);
  }

  Future<void> removeTask(Task task) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    tasks.remove(task);
    await emitTasks(tasks);
  }

  Future<void> checkTask(Task task) async {
    final tasks = _getTasks();
    if (tasks == null) return;
    final index = tasks.indexOf(task);
    tasks[index] = task.copyWith(check: !task.check);
    await emitTasks(tasks);
  }

  List<Task>? _getTasks() {
    final state = this.state;
    if (state is! GettedTaskBoardState) {
      return null;
    }
    return state.tasks.toList();
  }

  Future<void> emitTasks(List<Task> tasks) async {
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
