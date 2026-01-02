import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/task_engine.dart';

void main() {
  late TaskEngine taskEngine;

  setUp(() {
    taskEngine = TaskEngine();
  });

  /// ---------------- Create Task ----------------

  test("Creating a task with valid title", () {
    final task = taskEngine.createTask("Task 1");
    expect(task.title, "Task 1");
    expect(taskEngine.getPendingTasks().length, 1);
  });

  test("Can not create task with empty title", () {
    expect(() => taskEngine.createTask(""), throwsA(isA<ArgumentError>()));
  });

  test("Can not create task with white space title", () {
    expect(() => taskEngine.createTask("    "), throwsA(isA<ArgumentError>()));
  });

  test("Can not create task with more than 30 characters", () {
    expect(
      () => taskEngine.createTask("a" * 31),
      throwsA(isA<ArgumentError>()),
    );
  });

  test("Can not create task with duplicate title", () {
    taskEngine.createTask("Task 1");
    expect(() => taskEngine.createTask("Task 1"), throwsA(isA<StateError>()));
  });

  test("Can not create more than 5 tasks", () {
    for (var i = 0; i < 5; i++) {
      taskEngine.createTask("Task $i");
    }
    expect(() => taskEngine.createTask("Task 6"), throwsA(isA<StateError>()));
  });

  /// ---------------- Complete Task ----------------

  test("Complete existing task", () {
    final task = taskEngine.createTask("Task 1");

    taskEngine.completeTask(task.id);

    expect(taskEngine.getCompletedTasks(), isNotEmpty);
  });

  test("Can not complete non existing task", () {
    expect(
      () => taskEngine.completeTask("invalid-id"),
      throwsA(isA<StateError>()),
    );
  });

  test("Can not complete already completed task", () {
    final task = taskEngine.createTask("Task 1");

    taskEngine.completeTask(task.id);

    expect(() => taskEngine.completeTask(task.id), throwsA(isA<StateError>()));
  });

  /// ---------------- Delete Task ----------------

  test("Delete existing task (after 1 min)", () async* {
    final task = taskEngine.createTask("Task 1");
    await Future.delayed(const Duration(seconds: 61));
    taskEngine.deleteTask(task.id);

    expect(taskEngine.getPendingTasks(), isEmpty);
  });

  test("Can not delete non-existing task", () {
    expect(() => taskEngine.deleteTask("Task 1"), throwsA(isA<StateError>()));
  });

  test("Can not delete completed task", () {
    final task = taskEngine.createTask("Task 1");

    taskEngine.completeTask(task.id);

    expect(() => taskEngine.deleteTask(task.id), throwsA(isA<StateError>()));
  });
  test("Can not task within 1 min", () {
    final task = taskEngine.createTask("Task 1");

    expect(() => taskEngine.deleteTask(task.id), throwsA(isA<StateError>()));
  });
}
