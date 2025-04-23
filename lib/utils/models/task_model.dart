class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String category;
  final List<String> tags;
  final bool isImportant;
  final int priority;
  bool isCompleted;
  bool isExpanded;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.tags,
    required this.isImportant,
    required this.priority,
    this.isCompleted = false,
    this.isExpanded = false,
  });

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    List<String>? tags,
    bool? isImportant,
    int? priority,
    bool? isCompleted,
    bool? isExpanded,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isImportant: isImportant ?? this.isImportant,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
