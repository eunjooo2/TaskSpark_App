import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';

class Task {
  final String? id;
  final String? title;
  final String? description;
  final bool? isRepeatingTask;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? repeatPeriod;
  final String? priority;
  final bool? isDone;
  final String? categoryId;
  final DateTime? created;
  final DateTime? updated;

  const Task({
    this.id,
    this.title,
    this.description,
    this.isRepeatingTask,
    this.startDate,
    this.endDate,
    this.repeatPeriod,
    this.priority,
    this.isDone,
    this.categoryId,
    this.created,
    this.updated,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isRepeatingTask,
    DateTime? startDate,
    DateTime? endDate,
    String? repeatPeriod,
    String? priority,
    bool? isDone,
    String? categoryId,
    DateTime? created,
    DateTime? updated,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isRepeatingTask: isRepeatingTask ?? this.isRepeatingTask,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      repeatPeriod: repeatPeriod ?? this.repeatPeriod,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      categoryId: categoryId ?? this.categoryId,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "isRepeatingTask": isRepeatingTask,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "repeatPeriod": repeatPeriod,
      "priority": priority,
      "isDone": isDone,
      "category": categoryId,
    };
  }

  factory Task.fromRecord(RecordModel record) {
    return Task(
      id: record.id,
      title: record.get<String>('title'),
      description: record.get<String>('description'),
      isRepeatingTask: record.get<bool>('isRepeatingTask'),
      startDate: DateTime.tryParse(record.get<String>('startDate')),
      endDate: DateTime.tryParse(record.get<String>('endDate')),
      repeatPeriod: record.get<String>('repeatPeriod'),
      priority: record.get<String>('priority'),
      isDone: record.get<bool>('isDone'),
      categoryId: record.get<String>('category'),
      created: DateTime.tryParse(record.get<String>('created')),
      updated: DateTime.tryParse(record.get<String>('updated')),
    );
  }

  @override
  String toString() => jsonEncode({
    "id": id,
    "title": title,
    "description": description,
    "isRepeatingTask": isRepeatingTask,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "repeatPeriod": repeatPeriod,
    "priority": priority,
    "isDone": isDone,
    "categoryId": categoryId,
    "created": created?.toIso8601String(),
    "updated": updated?.toIso8601String(),
  });
}
