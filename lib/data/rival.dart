import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';

enum RivalRequestStatus { pending, draw, sender, receiver }

extension RivalRequestStatusExtension on RivalRequestStatus {
  String get name => toString().split('.').last;

  static RivalRequestStatus fromString(String status) {
    return RivalRequestStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => RivalRequestStatus.pending,
    );
  }
}

class RivalRequest {
  String id;
  DateTime start;
  DateTime end;
  String friendID;
  bool isAccepted;
  String senderID;
  RivalRequestStatus result;
  DateTime? created;

  @override
  String toString() {
    return jsonEncode({
      "id": id,
      "start": start.toIso8601String(),
      "end": end.toIso8601String(),
      "friendID": friendID,
      "isAccepted": isAccepted,
      "senderID": senderID,
      "result": result.name,
      "created": created?.toIso8601String(),
    });
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "start": start.toIso8601String(),
      "end": end.toIso8601String(),
      "friendID": friendID,
      "isAccepted": isAccepted,
      "senderID": senderID,
      "result": result.name,
      "created": created?.toIso8601String(),
    };
  }

  RivalRequest({
    required this.id,
    required this.start,
    required this.end,
    required this.friendID,
    required this.senderID,
    this.isAccepted = false,
    this.result = RivalRequestStatus.pending,
    this.created,
  });

  factory RivalRequest.fromRecord(RecordModel record) {
    return RivalRequest(
      id: record.data["id"],
      start: DateTime.parse(record.data["start"]),
      end: DateTime.parse(record.data["end"]),
      friendID: record.data["friend"],
      isAccepted: record.data["isAccepted"],
      senderID: record.data["sender"],
      result: RivalRequestStatusExtension.fromString(record.data["result"]),
      created: DateTime.parse(record.data["created"]),
    );
  }
}
