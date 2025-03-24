import 'package:pocketbase/pocketbase.dart';
import 'dart:convert';

class Task {
  String? content;

  Task({
    this.content
  });

  @override
  String toString() {
    return jsonEncode({
      "content": content
    });
  }

  factory Task.fromRecord(RecordModel record) {
    return Task(
      content: record.data["content"] as String?,
    );
  }
}
