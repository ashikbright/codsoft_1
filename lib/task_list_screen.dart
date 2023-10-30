import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'task.dart';
import 'task_detail_screen.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Task> taskList = [];
  TaskPriority selectedPriorityFilter = TaskPriority.all;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    File file = File('${appDocumentsDirectory.path}/tasks.json');

    if (file.existsSync()) {
      String content = await file.readAsString();
      final List<dynamic> taskData = json.decode(content);
      if (taskData != null) {
        setState(() {
          taskList.clear();
          taskList.addAll(taskData.map((data) {
            return Task.fromJson(data);
          }));
        });
      }
    }
  }

  Future<void> _saveTasks() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    File file = File('${appDocumentsDirectory.path}/tasks.json');
    await file.writeAsString(json.encode(taskList.map((task) => task.toJson()).toList()));
  }

  void _deleteTask(Task task) {
    setState(() {
      taskList.remove(task);
      _saveTasks();
    });
  }

  void _navigateToTaskDetailScreen(Task? task) async {
    final editedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );

    if (editedTask != null) {
      setState(() {
        if (task == null) {
          taskList.add(editedTask);
        } else {
          final index = taskList.indexOf(task);
          if (index != -1) {
            taskList[index] = editedTask;
          }
        }
        _saveTasks();
      });
    }
  }

  List<Task> _getFilteredTasks() {
    if (selectedPriorityFilter == TaskPriority.all) {
      return taskList;
    } else {
      return taskList.where((task) => task.priority == selectedPriorityFilter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
        actions: [
          // Priority Filter Dropdown in the App Bar
          DropdownButton<TaskPriority>(
            value: selectedPriorityFilter,
            onChanged: (TaskPriority? newValue) {
              setState(() {
                selectedPriorityFilter = newValue!;
              });
            },
            items: TaskPriority.values.map((priority) {
              return DropdownMenuItem<TaskPriority>(
                value: priority,
                child: Text(priority.toString().split('.').last),
              );
            }).toList(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          Task task = filteredTasks[index];
          return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteTask(task);
            },
            child: ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                "Status: ${task.isComplete ? 'Completed' : 'Pending'}",
                style: TextStyle(
                  color: task.isComplete ? Colors.green : Colors.red,
                ),
              ),
              trailing: Checkbox(
                value: task.isComplete,
                onChanged: task.isComplete
                    ? null
                    : (value) {
                  setState(() {
                    task.isComplete = value!;
                    _saveTasks();
                  });
                },
              ),
              onTap: () {
                _navigateToTaskDetailScreen(task);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToTaskDetailScreen(null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
