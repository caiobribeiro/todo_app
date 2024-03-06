import 'package:bloc/bloc.dart';
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

  Future<void> addTask(Task newTask) async {}
  Future<void> checkTask(Task task) async {}
  Future<void> removeTask(Task task) async {}
}
