import 'dart:convert';

enum FriendRequestStatus { pending, accepted, rejected, blocked }

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
  final String collectionId;
  final String senderId;
  final String receiverId;
  final FriendRequestStatus status;

  FriendRequest({
    required this.collectionId,
    required this.senderId,
    required this.receiverId,
    required this.status,
  });

  @override
  String toString() {
    return jsonEncode({
      "collectionId": collectionId,
      "senderId": senderId,
      "receiverId": receiverId,
      "status": status,
    });
  }

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      collectionId: json['id'],
      senderId: json['sender'],
      receiverId: json['receiver'],
      status: FriendRequestStatusExtension.fromString(json['status']),
    );
  }
}
