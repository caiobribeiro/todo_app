import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/src/cubits/board_cubit.dart';
import 'package:todo_app/src/models/task.dart';
import 'package:todo_app/src/repositories/board_repository.dart';
import 'package:todo_app/src/state/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  group('Fetch tasks |', () {
    test('Should fetch all tasks', () async {
      when(() => repository.fetch()).thenAnswer((_) async => [
            const Task(id: 1, descrption: '1', check: false),
          ]);

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<LoadingBoardState>(),
            isA<GettedTaskBoardState>(),
          ],
        ),
      );
      await cubit.fetchTasks();
    });

    test('Should return a state of Failure', () async {
      when(() => repository.fetch()).thenThrow(Exception('Error'));

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<LoadingBoardState>(),
            isA<FailureBoardState>(),
          ],
        ),
      );
      await cubit.fetchTasks();
    });
  });
  group('Add task |', () {
    test('Should add task to tasks', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<GettedTaskBoardState>(),
          ],
        ),
      );
      const task = Task(id: 1, descrption: 'task01');
      await cubit.addTask(task);
      final state = cubit.state as GettedTaskBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks, [task]);
    });

    test('Should return a state of Failure', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailureBoardState>(),
          ],
        ),
      );
      const task = Task(id: 1, descrption: 'task01');
      await cubit.addTask(task);
    });
  });
  group('Remove task |', () {
    test('Should remove task to tasks', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      const task = Task(id: 1, descrption: 'task01');
      cubit.addTasks([task]);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<GettedTaskBoardState>(),
          ],
        ),
      );

      await cubit.removeTask(task);
      final state = cubit.state as GettedTaskBoardState;

      expect(state.tasks.length, 0);
    });

    test('Should return a state of Failure', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));

      const task = Task(id: 1, descrption: 'task01');
      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailureBoardState>(),
          ],
        ),
      );

      await cubit.removeTask(task);
    });
  });
  group('Check task |', () {
    test('Should remove task to tasks', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      const task = Task(id: 1, descrption: 'task01');
      cubit.addTasks([task]);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);
      expect((cubit.state as GettedTaskBoardState).tasks.first.check, false);

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<GettedTaskBoardState>(),
          ],
        ),
      );

      await cubit.checkTask(task);
      final state = cubit.state as GettedTaskBoardState;

      expect(state.tasks.length, 1);
      expect(state.tasks.first.check, true);
    });

    test('Should return a state of Failure', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));

      const task = Task(id: 1, descrption: 'task01');
      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emitsInOrder(
          [
            isA<FailureBoardState>(),
          ],
        ),
      );

      await cubit.checkTask(task);
    });
  });
}
