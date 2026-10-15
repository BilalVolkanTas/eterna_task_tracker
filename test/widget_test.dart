import 'package:flutter_test/flutter_test.dart';
import 'package:eterna_task_tracker/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EternaApp());
  });
}
