import 'package:get/get.dart';
import 'package:instant_write/repository/task_data_repository.dart';
import 'package:instant_write/models/task_data.dart';

class TaskDataController extends GetxController {
  final TaskDataRepository _taskDataRepository = Get.find();

  final todos = <TaskData>[].obs;
  final pickDate = clearTime().obs;

  @override
  void onInit() {
    super.onInit();
    fetchTaskDatas();
  }

  void addTaskData(TaskData taskData, DateTime datetime) async {
    await _taskDataRepository.addTaskData(taskData);
    fetchTaskDatas(datetime: datetime);
  }

  void fetchTaskDatas({DateTime? datetime}) async {
    var now = DateTime.now();
    var startTimeNow = DateTime(now.year, now.month, now.day);
    todos.value =
        await _taskDataRepository.getTaskDatas(datetime ?? startTimeNow);
  }

  void updateTaskData(TaskData taskData, DateTime datetime) async {
    await _taskDataRepository.updateTaskData(taskData);
    fetchTaskDatas(datetime: datetime);
  }

  void deleteTaskData(int id, DateTime datetime) async {
    await _taskDataRepository.deleteTaskData(id);
    fetchTaskDatas(datetime: datetime);
  }

  static DateTime clearTime() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
