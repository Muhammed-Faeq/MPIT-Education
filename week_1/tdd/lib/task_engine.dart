import 'package:tdd/task.dart';

class TaskEngine {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  /// -- Create task and return it
  Task createTask(String title) {
    if (title.isEmpty || title.trim().isEmpty) {
      throw ArgumentError("Task title can not be empty or white space only");
    }
    if (title.length > 30) {
      throw ArgumentError("Task title can not be more than 30 characters");
    }
    if (_tasks.any((task) => task.title == title)) {
      /// -- another way to do that
      // _tasks.where((task) => task.title == title).isNotEmpty
      throw StateError("Task with title $title already exists");
    }
    if (_tasks.length >= 5) {
      throw StateError("Can not create more than 5 tasks");
    }

    final task = Task(id: "$title-${_tasks.length + 1}", title: title);

    _tasks.add(task);
    return task;
  }

  /// -- Complete a task by ID
  void completeTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      throw StateError("Task not found");
    }

    final task = _tasks[index];
    if (task.isCompleted) {
      throw StateError("Task is already completed");
    }

    _tasks[index] = task.copyWith(isCompleted: true);
  }

  /// -- Delete a task by ID
  void deleteTask(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);

    if (taskIndex == -1) {
      throw StateError("Task not found to delete");
    }

    final task = _tasks[taskIndex];

    if (task.isCompleted) {
      throw StateError("Can not delete completed task");
    }

    final now = DateTime.now();
    final difference = now.difference(task.createdAt);

    if (difference.inMinutes < 1) {
      throw StateError("Can not delete task within 1 minute of creation");
    }

    _tasks.removeAt(taskIndex);
  }

  List<Task> getCompletedTasks() =>
      _tasks.where((task) => task.isCompleted).toList();

  List<Task> getPendingTasks() =>
      _tasks.where((task) => !task.isCompleted).toList();
}
