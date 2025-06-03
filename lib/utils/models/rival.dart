import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';
import 'package:task_spark/utils/models/friend.dart';
import 'package:task_spark/utils/models/user.dart';

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
  String? id;
  DateTime? start;
  DateTime? end;
  FriendRequest? friend;
  bool? isAccepted;
  SearchUser? sender;
  RivalRequestStatus? result;
  DateTime? created;

  @override
  String toString() {
    return jsonEncode({
      "id": id,
      "start": start?.toIso8601String(),
      "end": end?.toIso8601String(),
      "friend": friend.toString(),
      "isAccepted": isAccepted,
      "sender": sender.toString(),
      "result": result?.name,
      "created": created?.toIso8601String(),
    });
  }

  RivalRequest({
    required this.id,
    this.start,
    this.end,
    this.friend,
    this.isAccepted = false,
    this.sender,
    this.result,
    this.created,
  });

  factory RivalRequest.fromRecord(RecordModel record) {
    return RivalRequest(
      id: record.data["id"],
      start: record.data["start"],
      end: record.data["end"],
      friend: record.data["friend"],
      isAccepted: record.data["isAccepted"],
      sender: record.data["sender"],
      result: record.data["result"],
      created: record.data["created"],
    );
  }
}
