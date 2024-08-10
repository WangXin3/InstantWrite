import 'package:get/get.dart';
import 'package:instant_write/models/task_data.dart';
import 'package:instant_write/repository/task_data_repository.dart';

class SummarizeController extends GetxController {
  final TaskDataRepository _taskDataRepository = Get.find();
  final todos = <TaskData>[].obs;
  final List<String> data = ['今日', '本周', '本月', '自定'];
  final startTime = clearTime().obs;
  final endTime = clearTime().add(const Duration(hours: 23, minutes: 59, seconds: 59)).obs;
  final select = '今日'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTaskDatasBetween();
  }

  void fetchTaskDatasBetween({DateTime? startTime, DateTime? endTime}) async {
    var now = DateTime.now();
    var startTimeNow = DateTime(now.year, now.month, now.day);
    var endTimeNow =
        startTimeNow.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    todos.value = await _taskDataRepository.getTaskDatasBetween(
        startTime ?? startTimeNow, endTime ?? endTimeNow);
  }

  static DateTime clearTime() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
