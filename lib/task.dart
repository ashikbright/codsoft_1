enum TaskPriority { low, medium, high, all }

class Task {
  String title;
  String description;
  DateTime? dueDate;
  bool isComplete;
  TaskPriority priority;

  Task({
    required this.title,
    this.description = '',
    this.dueDate,
    this.isComplete = false,
    this.priority = TaskPriority.medium,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'isComplete': isComplete,
      'priority': priority.toString().split('.').last,
    };
  }

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        dueDate = json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        isComplete = json['isComplete'],
        priority = TaskPriority.values.firstWhere(
              (e) => e.toString().split('.').last == json['priority'],
          orElse: () => TaskPriority.medium,
        );
}
