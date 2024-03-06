import 'package:todo_app/src/models/task.dart';
import 'package:todo_app/src/repositories/board_repository.dart';
import 'package:todo_app/src/repositories/isar/isar_datasource.dart';

class IsarBoardRepository implements BoardRepository {
  final IsarDatasource datasource;

  IsarBoardRepository(this.datasource);

  @override
  Future<List<Task>> fetch() {
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> update(List<Task> tasks) {
    throw UnimplementedError();
  }
}
