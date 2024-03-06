import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/src/cubits/board_cubit.dart';
import 'package:todo_app/src/models/task.dart';
import 'package:todo_app/src/repository/board_repository.dart';
import 'package:todo_app/src/state/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  final repository = BoardRepositoryMock();
  final cubit = BoardCubit(repository);
  tearDown(() => reset(repository));

  group('fetchTasks |', () {
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
    // testWidgets('Should add task to tasks', (tester) async {});
    // testWidgets('Should update task to checked', (tester) async {});
    // testWidgets('Should remove task of tasks', (tester) async {});
  });
}
