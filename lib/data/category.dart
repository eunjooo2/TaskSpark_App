import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';

class Category {
  final String? id;
  final String? name;
  final String? emoji;
  final String? color;

  const Category({
    this.id,
    this.name,
    this.emoji,
    this.color,
  });

  Category copyWith({
    String? id,
    String? name,
    String? emoji,
    String? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "emoji": emoji,
      "color": color,
    };
  }

  factory Category.fromRecord(RecordModel record) {
    return Category(
      id: record.id,
      name: record.get<String>('name'),
      emoji: record.get<String>('emoji'),
      color: record.get<String>('color'),
    );
  }

  @override
  String toString() => jsonEncode({
        "id": id,
        "name": name,
        "emoji": emoji,
        "color": color,
      });
}
