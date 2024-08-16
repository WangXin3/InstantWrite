import 'package:isar/isar.dart';
part 'task_data.g.dart';

@collection
class TaskData {
  Id? id;
  DateTime createdAt; // 创建时间
  String type; // 任务类型
  String scope;
  String subject;
  String body;
  String footer;

  TaskData(
      {this.id,
      required this.subject,
      this.type = 'default',
      this.scope = '',
      this.body = '',
      this.footer = '',
      required this.createdAt});

  factory TaskData.parse(String message) {
    // 定义一个正则表达式模式，匹配\r
    RegExp digitPattern = RegExp('\r');
    // 将模式的所有出现替换为一个空字符串
    message = message.replaceAll(digitPattern, '');

    final lines = message.split('\n');
    final titlePattern = RegExp(r'^(\w+)(?:\(([^)]+)\))?: (.+)$');
    String type = "default", scope = "", subject = "", body = "", footer = "";

    if (lines.isNotEmpty) {
      final titleMatch = titlePattern.firstMatch(lines[0]);
      if (titleMatch != null) {
        type = titleMatch.group(1)!;
        scope = titleMatch.group(2) ?? '';
        subject = titleMatch.group(3)!;

        if (lines.length > 1) {
          final bodyStartIndex = lines.indexWhere((line) => line.isEmpty) + 1;
          if (bodyStartIndex > 0 && bodyStartIndex < lines.length) {
            body = lines
                .sublist(bodyStartIndex, lines.length - 1)
                .join('\n')
                .trim();
          }

          footer = lines.last.trim();
        }
      } else {
        subject = message;
      }
    }

    return TaskData(
        type: type,
        scope: scope,
        subject: subject,
        body: body,
        footer: footer,
        createdAt: DateTime.now());
  }

  @override
  String toString() {
    if (type == 'default') {
      return subject;
    } else {
      var result = type;
      if (scope != '') {
        result += '($scope)';
      }
      result += ': ';
      if (subject != '') {
        result += subject;
      }

      if (body != '') {
        result += '\n\n$body';
      }

      if (footer != '') {
        result += '\n\n$footer';
      }

      // return '$type($scope): $subject\n\n$body\n\n$footer';
      return result;
    }
  }
}
