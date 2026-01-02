import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/task.dart';

void main() {
  test("Task is not completed by default when created", () {
    final task = Task(id: "1", title: "Task 1");

    expect(task.isCompleted, false);
  });
  test("createdAt is automatically assigned", () {
    final task = Task(id: "2", title: "Task 2");
    expect(task.createdAt, isNotNull);
  });
  test("Completing a task marks it as completed", () {
    final task = Task(id: "3", title: "Task 3");

    expect(task.isCompleted, false);
    final completedTask = task.completed();
    expect(completedTask.isCompleted, true);
  });
  test("Completing an already completed task throws StateError", () {
    final task = Task(id: "4", title: "Task 4", isCompleted: true);

    expect(() => task.completed(), throwsA(isA<StateError>()));
  });
}
