import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/src/repositories/isar/task_model.dart';

class IsarDatasource {
  Isar? _isar;

  Future<Isar> _getInstance() async {
    if (_isar != null) {
      return _isar!;
    }
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [TaskModelSchema],
      directory: dir.path,
    );
    return isar;
  }

  Future<List<TaskModel>> getTasks() async {
    final isar = await _getInstance();
    return await isar.taskModels.where().findAll();
  }

  Future<void> deleteAllTasks() async {
    final isar = await _getInstance();
    await isar.writeTxn(() async {
      await isar.taskModels.where().deleteAll();
    });
  }

  Future<void> putAllTasks(List<TaskModel> models) async {
    final isar = await _getInstance();
    await isar.writeTxn(() async {
      await isar.taskModels.putAll(models);
    });
  }
}
