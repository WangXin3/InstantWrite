import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instant_write/controller/summarize.dart';
import 'package:instant_write/models/task_data.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class SummarizePage extends GetView<SummarizeController> {
  SummarizePage({super.key});
  final dateFormat = DateFormat('yyyy年MM月dd日');

  @override
  Widget build(BuildContext context) {
    controller.fetchTaskDatasBetween(
        startTime: controller.startTime.value,
        endTime: controller.endTime.value);
    final theme = Theme.of(context);

    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                Text(
                  '总结',
                  style: TextStyle(
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                      letterSpacing: -1),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 28,
                        // margin: const EdgeInsets.only(left: 15),
                        child: DropdownMenu(
                          enableSearch: false,
                          width: 100,
                          dropdownMenuEntries: _buildMenuList(controller.data),
                          initialSelection: controller.select.value,
                          onSelected: (value) async {
                            // 今日
                            if (value == controller.data[0]) {
                              controller.startTime.value = clearTime();
                              controller.endTime.value =
                                  controller.startTime.value.add(const Duration(
                                      hours: 23, minutes: 59, seconds: 59));
                            } else if (value == controller.data[1]) {
                              // 本周
                              DateTime now = clearTime();
                              int daysOfWeek = now.weekday - 1;
                              controller.startTime.value = DateTime(
                                  now.year, now.month, now.day - daysOfWeek);
                              controller.endTime.value =
                                  controller.startTime.value.add(const Duration(
                                      days: 6,
                                      hours: 23,
                                      minutes: 59,
                                      seconds: 59));
                            } else if (value == controller.data[2]) {
                              // 本月
                              DateTime now = clearTime();
                              controller.startTime.value =
                                  DateTime(now.year, now.month, 1);
                              controller.endTime.value = DateTime(
                                  now.year, now.month + 1, 0, 23, 59, 59);
                            } else {
                              // 自定义

                              var dateTimeRange = await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(2000, 1, 1),
                                  lastDate: DateTime(2050, 12, 31),
                                  currentDate: clearTime(),
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                  helpText: '请选择日期区间',
                                  cancelText: '取消',
                                  confirmText: '确定',
                                  saveText: '完成');

                              controller.startTime.value = dateTimeRange!.start;
                              controller.endTime.value = dateTimeRange.end.add(
                                  const Duration(
                                      hours: 23, minutes: 59, seconds: 59));
                            }

                            controller.fetchTaskDatasBetween(
                                startTime: controller.startTime.value,
                                endTime: controller.endTime.value);
                            controller.select.value = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Obx(() => Text(
                    '${dateFormat.format(controller.startTime.value)} - ${dateFormat.format(controller.endTime.value)}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        letterSpacing: -1),
                  )),
            )
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
            child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Obx(() => SelectableText(
                          getSummarizeData(),
                          style: const TextStyle(fontSize: 22.0),
                        )),
                  )),
                ],
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.content_copy),
                onPressed: () {
                  // 复制
                  Clipboard.setData(ClipboardData(text: getSummarizeData()))
                      .then((value) => {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('已复制!'),
                                duration: Duration(seconds: 2),
                              ),
                            )
                          });
                },
                label: const Text('复制'),
              ),
            ),
          ],
        )),
      ],
    );
  }

  DateTime clearTime() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String getSummarizeData() {
    controller.todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    List<String> subjectList = [];

    for (var todo in controller.todos) {
      subjectList.add("●${todo.subject}");
      if (todo.body != '') {
        List<String> bodyList = todo.body.split('\n');
        subjectList.addAll(bodyList.map((b) => "  ○$b"));
      }
    }

    return subjectList.join('\n');
  }

  List<DropdownMenuEntry<String>> _buildMenuList(List<String> data) {
    return data.map((String value) {
      return DropdownMenuEntry<String>(value: value, label: value);
    }).toList();
  }
}
