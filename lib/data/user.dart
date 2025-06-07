import 'dart:convert';
import 'package:pocketbase/pocketbase.dart';

class User {
  String? collectionId;
  String? collectionName;
  String? id;
  String? email;
  bool? emailVisibility;
  bool? verified;
  String? name;
  String? avatar;
  num? exp;
  int? point;
  Map<String, dynamic>? inventory;
  DateTime? created;
  DateTime? updated;
  String? accessToken;
  String? nickname;
  int? tag;
  Map<String, dynamic>? metadata;

  User({
    this.collectionId,
    this.collectionName,
    this.id,
    this.email,
    this.emailVisibility,
    this.verified,
    this.name,
    this.nickname,
    this.tag,
    this.point,
    this.avatar,
    this.exp,
    this.inventory,
    this.created,
    this.updated,
    this.accessToken,
    this.metadata,
  });

  @override
  String toString() {
    return jsonEncode({
      "collectionId": collectionId,
      "collectionName": collectionName,
      "id": id,
      "accessToken": accessToken,
      "email": email,
      "emailVisibility": emailVisibility,
      "verified": verified,
      "name": name,
      "avatar": avatar,
      "exp": exp,
      "point": point,
      "inventory": inventory,
      "created": created?.toIso8601String(),
      "updated": updated?.toIso8601String(),
    });
  }

  factory User.fromRecord(RecordModel record) {
    return User(
      collectionId: record.collectionId,
      collectionName: record.collectionName,
      id: record.id,
      email: record.data["email"] as String?,
      emailVisibility: record.data["emailVisibility"] as bool?,
      verified: record.data["verified"] as bool?,
      name: record.data["name"] as String?,
      nickname: record.data["nickname"] as String?,
      tag: record.data["tag"] as int?,
      avatar: record.data["avatar"] as String?,
      exp: record.data["exp"] as num?,
      point: record.data["point"] ?? record.data["point"] ?? 0,
      inventory: record.data["inventory"] as Map<String, dynamic>?,
      created: DateTime.tryParse(record.created),
      updated: DateTime.tryParse(record.updated),
      metadata: record.data["metadata"] as Map<String, dynamic>?,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final user = json["data"];
    print(user);
    return User(
      accessToken: json["token"],
      id: user["id"],
      email: user["email"] as String?,
      verified: user["verified"] as bool?,
      name: user["name"] as String?,
      avatar: user["avatar"] as String?,
      nickname: user["nickname"] as String?,
      tag: user["tag"] as int?,
      exp: user["exp"] as num?,
      point: user["point"] ?? user["point"] ?? 0,
      inventory: user["inventory"] as Map<String, dynamic>?,
      created: DateTime.tryParse(user["created"]),
      updated: DateTime.tryParse(user["updated"]),
      metadata: user["metadata"] as Map<String, dynamic>?,
    );
  }

  /// ✅ avatarUrl 생성기 (정상 이미지 렌더링용)
  String get avatarUrl {
    if (avatar == null ||
        avatar!.isEmpty ||
        id == null ||
        collectionId == null) {
      return "https://example.com/default-profile.png"; // 대체 이미지 경로
    }
    return "https://pb.aroxu.me/api/files/$collectionId/$id/$avatar";
  }
}

class SearchData {
  int? count;
  List<SearchUser>? data;
  bool? success;

  SearchData({required this.count, required this.data, required this.success});

  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
      count: json["count"] as int,
      data: (json["data"] as List<dynamic>)
          .map((e) => SearchUser.fromJson(e))
          .toList(),
      success: json["success"] as bool,
    );
  }
}

class SearchUser {
  String? avatar;
  DateTime? created;
  num? exp;
  String? id;
  String? nickname;
  int? tag;

  SearchUser({
    required this.avatar,
    required this.created,
    required this.exp,
    required this.id,
    required this.nickname,
    required this.tag,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {
    return SearchUser(
      avatar: json["avatar"] != null ? json["avatar"] as String : null,
      created: DateTime.tryParse(json["created"]),
      exp: json["exp"],
      id: json["id"] as String,
      nickname: json["nickname"] as String,
      tag: json["tag"],
    );
  }
}
