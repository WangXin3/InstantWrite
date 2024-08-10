import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instant_write/controller/task_data.dart';
import 'package:instant_write/models/task_data.dart';
import 'package:intl/intl.dart';

class TodayPage extends GetView<TaskDataController> {
  TodayPage({super.key});

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.fetchTaskDatas(datetime: controller.pickDate.value);
    final theme = Theme.of(context);

    var buttonStyle = ButtonStyle(
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(0)));

    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                Text(
                  '我的一天',
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
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        child: IconButton(
                            onPressed: () {
                              var now = DateTime.now();
                              controller.pickDate.value =
                                  DateTime(now.year, now.month, now.day);
                              controller.fetchTaskDatas(
                                  datetime: controller.pickDate.value);
                            },
                            icon: const Icon(
                              Icons.undo_outlined,
                              size: 24.0,
                            ),
                            style: buttonStyle,
                            tooltip: '回到今日',
                            alignment: Alignment.center),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.only(left: 15),
                        child: IconButton(
                            onPressed: () async {
                              controller.pickDate.value = (await showDatePicker(
                                      context: context,
                                      initialDate: controller.pickDate.value, //初始化日期
                                      firstDate: DateTime(2010), // 起始日期
                                      lastDate: DateTime(2050), //终止日期
                                      helpText: '选择日期',
                                      cancelText: '取消',
                                      confirmText: '确定',
                                      // 可选范围
                                      selectableDayPredicate: (date) {
                                        // date.difference用于计算日期差
                                        return date
                                                .difference(DateTime.now())
                                                .inMilliseconds <
                                            0;
                                      })) ??
                                  controller.pickDate.value;

                              controller.fetchTaskDatas(
                                  datetime: controller.pickDate.value);
                            },
                            icon: const Icon(
                              Icons.calendar_month,
                              size: 24.0,
                            ),
                            style: buttonStyle,
                            tooltip: '选择日期',
                            alignment: Alignment.center),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Obx(() => Text(
                    '${controller.pickDate.value.month}月${controller.pickDate.value.day}日, ${DateFormat('EEEE', 'zh_CN').format(controller.pickDate.value)}',
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
            child: Obx(() => controller.todos.isEmpty
                ? const Text('没有数据')
                : ListView.separated(
                    itemCount: controller.todos.length,
                    itemBuilder: (BuildContext context, int index) {
                      var value = controller.todos[index];
                      return Container(
                        decoration: const BoxDecoration(
                            // color: Colors.white,
                            // border: BorderDirectional(top: BorderSide()),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        margin: const EdgeInsets.only(
                          top: 2,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 70,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${value.type}:',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            value.subject,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: value.body == '' ? null : Text(value.body),
                          trailing: Text(dateFormat.format(value.createdAt)),
                          enabled: true,
                          // selected: true,
                          // dense: true,
                          onTap: () async {
                            _updateController.text = value.toString();
                            bool? update = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("编辑"),
                                    content: TextField(
                                      autofocus: true,
                                      controller: _updateController,
                                      maxLines: null,
                                      decoration:
                                          const InputDecoration(hintText: '已办'),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("取消"),
                                        onPressed: () => Navigator.of(context)
                                            .pop(), // 关闭对话框
                                      ),
                                      TextButton(
                                        child: const Text("修改"),
                                        onPressed: () {
                                          //关闭对话框并返回true
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    ],
                                  );
                                });

                            if (update != null && update) {
                              var newTaskData =
                                  TaskData.parse(_updateController.text);
                              newTaskData.id = value.id;
                              newTaskData.createdAt = value.createdAt;
                              controller.updateTaskData(
                                  newTaskData, controller.pickDate.value);
                            }
                          },
                          onLongPress: () async {
                            bool? delete = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("删除"),
                                    content: const Text('确定删除该已办吗？'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text("取消"),
                                        onPressed: () => Navigator.of(context)
                                            .pop(), // 关闭对话框
                                      ),
                                      TextButton(
                                        child: const Text("确定"),
                                        onPressed: () {
                                          //关闭对话框并返回true
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    ],
                                  );
                                });
                            if (delete != null && delete) {
                              controller.deleteTaskData(
                                  value.id!, controller.pickDate.value);
                            }
                          },
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      height: 2.0,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ))),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: const BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Obx(() => TextField(
                enabled: controller.pickDate.value == clearTime(),
                controller: _controller,
                obscureText: false,
                maxLines: null,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          // height: 48,
                          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: const Icon(Icons.add),
                        ),
                        const Text('添加已办')
                      ],
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    border: const UnderlineInputBorder()),
              )),
        ),
        Obx(() => ElevatedButton.icon(
              icon: const Icon(Icons.done),
              onPressed: controller.pickDate.value == clearTime() ? _toggleButton : null,
              label: const Text('提交'),
            ))
      ],
    );
  }

  void _toggleButton() {
    String value = _controller.text;
    if (value == '') {
      return;
    }
    controller.addTaskData(TaskData.parse(value), controller.pickDate.value);
    _controller.clear();
  }

  static DateTime clearTime() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
