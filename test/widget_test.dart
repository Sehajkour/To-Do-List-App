import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cscorner/main.dart';  // Adjust this import based on your actual file structure

void main() {
  testWidgets('Task adding and checking functionality', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the app starts with no tasks.
    expect(find.text('No tasks'), findsOneWidget);

    // Tap the '+' icon to open the dialog.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(); // Trigger a frame to display the dialog.

    // Enter a task title and select a due date.
    await tester.enterText(find.byType(TextField), 'New Task');
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pump(); // Trigger a frame to display the date picker.

    // Select a date (You may need to mock or select a date here based on your implementation).
    // Example assumes default date selection.
    // If you need to simulate date selection, you might have to use additional libraries or mocks.

    // Tap 'Add' to confirm adding the task.
    await tester.tap(find.text('Add'));
    await tester.pump(); // Trigger a frame to update the task list.

    // Verify that the new task is added.
    expect(find.text('New Task'), findsOneWidget);
    expect(find.text('No tasks'), findsNothing);
  });
}
