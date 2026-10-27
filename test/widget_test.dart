import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';

void main() {
  testWidgets('scores correct answers, locks each answer, and restarts',
      (tester) async {
    await tester.pumpWidget(const QuizApp());
    expect(questions, hasLength(10));

    final firstAnswer = questions[0].options[questions[0].answerIndex];
    await tester.tap(find.text(firstAnswer).first);
    await tester.pumpAndSettle();
    expect(find.text('Correct!'), findsOneWidget);
    await tester.tap(find.text(questions[0].options[(questions[0].answerIndex + 1) % 4]).first);
    await tester.pump();
    expect(find.text('Score 1'), findsOneWidget);

    for (var i = 0; i < questions.length; i++) {
      if (i > 0) {
        final answer = find.byType(OutlinedButton).at(questions[i].answerIndex);
        await tester.ensureVisible(answer);
        await tester.tap(answer);
        await tester.pumpAndSettle();
      }
      await tester.ensureVisible(find.text(i == questions.length - 1 ? 'See results' : 'Next question'));
      await tester.tap(find.text(i == questions.length - 1 ? 'See results' : 'Next question'));
      await tester.pumpAndSettle();
    }

    expect(find.text('10 / 10'), findsOneWidget);
    await tester.tap(find.text('Restart quiz'));
    await tester.pumpAndSettle();
    expect(find.text('Question 1 of 10'), findsOneWidget);
    expect(find.text('Score 0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

