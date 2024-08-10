import 'package:flutter_test/flutter_test.dart';
import 'package:instant_write/models/task_data.dart';

void main() {
  const commitMessage = '''feat(user): add login functionality

Add login functionality for user authentication.
- Implemented login API
- Added login page with form validation

Closes #123''';

  test('测试格式化提交信息', () {
    final parsedMessage = TaskData.parse(commitMessage);
    expect(parsedMessage.subject, "add login functionality");
    expect(parsedMessage.type, 'feat');
    expect(parsedMessage.scope, 'user');
    expect(
        parsedMessage.body, '''Add login functionality for user authentication.
- Implemented login API
- Added login page with form validation''');
    expect(parsedMessage.footer, 'Closes #123');
  });
}
