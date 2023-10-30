import 'package:flutter/material.dart';
import 'task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> tasks = [];

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task oldTask, Task newTask) {
    final index = tasks.indexOf(oldTask);
    if (index != -1) {
      tasks[index] = newTask;
      notifyListeners();
    }
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }
}
