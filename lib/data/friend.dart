import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';

enum FriendRequestStatus { pending, accepted, blocked }

extension FriendRequestStatusExtension on FriendRequestStatus {
  String get name => toString().split('.').last;

  static FriendRequestStatus fromString(String status) {
    return FriendRequestStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => FriendRequestStatus.pending,
    );
  }
}

class FriendRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final FriendRequestStatus status;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
  });

  @override
  String toString() {
    return jsonEncode({
      "id": id,
      "senderId": senderId,
      "receiverId": receiverId,
      "status": status.name,
    });
  }

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json["id"],
      senderId: json['sender'],
      receiverId: json['receiver'],
      status:
          _convertStatus(json['isAccepted'] as bool, json['isBlocked'] as bool),
    );
  }

  factory FriendRequest.fromRecordModel(RecordModel record) {
    return FriendRequest(
      id: record.data["id"],
      senderId: record.data['sender'],
      receiverId: record.data['receiver'],
      status: _convertStatus(
          record.data['isAccepted'] as bool, record.data['isBlocked'] as bool),
    );
  }
}

FriendRequestStatus _convertStatus(bool isAccepted, bool isBlocked) {
  if (isBlocked == true) {
    return FriendRequestStatus.blocked;
  } else if (isAccepted == true) {
    return FriendRequestStatus.accepted;
  } else {
    return FriendRequestStatus.pending;
  }
}
