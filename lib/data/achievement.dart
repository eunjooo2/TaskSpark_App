import 'package:pocketbase/pocketbase.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String type;
  final bool isOnce;
  final bool isHidden;
  final Map<String, int> amount;
  final Map<String, dynamic>? reward;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.amount,
    required this.isOnce,
    this.isHidden = false,
    this.reward,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json["id"] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      isOnce: json['isOnce'],
      isHidden: json['isHidden'] ?? false,
      amount: Map<String, int>.from(json['amount'] ?? {}),
      reward: json['reward'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'isOnce': isOnce,
      'isHidden': isHidden,
      'amount': amount,
      if (reward != null) 'reward': reward,
    };
  }

  factory Achievement.fromRecord(RecordModel record) {
    return Achievement(
      id: record.data["id"],
      title: record.data["title"],
      description: record.data["description"],
      type: record.data["type"],
      amount: Map<String, int>.from(record.data["amount"]),
      reward: record.data["reward"] as Map<String, dynamic>,
      isOnce: record.data["isOnce"],
      isHidden: record.data["isHidden"],
    );
  }
}
