import 'package:instant_write/models/task_data.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class TaskDataRepository extends GetxService {
  late Isar _isar;

  Future<TaskDataRepository> init() async {
    _isar = await open();
    return this;
  }

  // 获取 Isar 实例
  Future<Isar> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open([TaskDataSchema],
        directory: dir.path, name: 'TaskData');
    return isar;
  }

  // 增加一个待办事项
  Future<void> addTaskData(TaskData taskData) async {
    await _isar.writeTxn(() async {
      await _isar.taskDatas.put(taskData);
    });
  }

// 获取待办事项（支持筛选）
  Future<List<TaskData>> getTaskDatas(DateTime datetime) async {
    List<TaskData>? todos;

    final later =
        datetime.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    todos = await _isar.taskDatas
        .filter()
        // 查询位于指定日期所有的已办
        .createdAtBetween(datetime, later)
        .sortByCreatedAtDesc()
        .findAll();

    return todos.toList();
  }

  Future<List<TaskData>> getTaskDatasBetween(
      DateTime startTime, DateTime endTime) async {
    List<TaskData>? todos = [];

    todos = await _isar.taskDatas
        .filter()
        // 查询位于指定日期所有的已办
        .createdAtBetween(startTime, endTime)
        .sortByCreatedAtDesc()
        .findAll();

    return todos.toList();
  }

  // 更新一个待办事项
  Future<void> updateTaskData(TaskData taskData) async {
    await _isar.writeTxn(() async {
      await _isar.taskDatas.put(taskData);
    });
  }

  // 删除一个待办事项
  Future<void> deleteTaskData(int id) async {
    await _isar.writeTxn(() async {
      await _isar.taskDatas.delete(id);
    });
  }
}
