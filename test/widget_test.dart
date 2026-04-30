import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:prepquest/app.dart';
import 'package:prepquest/data/local/local_storage.dart';
import 'package:prepquest/providers/prepquest_provider.dart';

void main() {
  testWidgets('PrepQuest smoke test', (WidgetTester tester) async {
    final provider = PrepQuestProvider(LocalStorage());

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const PrepQuestApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Welcome back'), findsOneWidget);
    expect(find.text('Choose your target exam'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Exams'), findsOneWidget);

    await tester.tap(find.text('Exams'));
    await tester.pumpAndSettle();

    expect(find.text('Choose your exam'), findsOneWidget);

    await tester.tap(find.text('Tracker'));
    await tester.pumpAndSettle();

    expect(find.text('Syllabus'), findsOneWidget);
    expect(find.text('Daily'), findsOneWidget);
  });
}
