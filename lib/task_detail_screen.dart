import 'package:flutter/material.dart';
import 'task.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task? task;

  TaskDetailScreen({this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _isComplete = false;
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _isComplete = widget.task!.isComplete;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Enter task title",
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "Enter task description",
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Due Date",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  setState(() {
                    _dueDate = selectedDate;
                  });
                }
              },
              child: Text(
                _dueDate != null
                    ? "${_dueDate!.year}-${_dueDate!.month}-${_dueDate!.day}"
                    : "Select a due date",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Priority",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            DropdownButton<TaskPriority>(
              value: _priority,
              onChanged: (TaskPriority? newValue) {
                setState(() {
                  _priority = newValue!;
                });
              },
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem<TaskPriority>(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Checkbox(
                  value: _isComplete,
                  onChanged: (value) {
                    setState(() {
                      _isComplete = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save or update the task here
          Navigator.pop(context, Task(
            title: _titleController.text,
            description: _descriptionController.text,
            isComplete: _isComplete,
            dueDate: _dueDate,
            priority: _priority,
          ));
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
