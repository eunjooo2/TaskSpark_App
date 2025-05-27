import 'package:pocketbase/pocketbase.dart';
import 'dart:convert';

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
  Map<String, dynamic>? inventory;
  DateTime? created;
  DateTime? updated;
  String? accessToken;
  String? nickname;
  int? tag;

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
    this.avatar,
    this.exp,
    this.inventory,
    this.created,
    this.updated,
    this.accessToken,
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
      avatar: record.data["avatar"] as String?,
      exp: record.data["exp"] as num?,
      inventory: record.data["inventory"] as Map<String, dynamic>?,
      created: DateTime.tryParse(record.created),
      updated: DateTime.tryParse(record.updated),
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final user = json["data"];
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
      inventory: user["inventory"] as Map<String, dynamic>?,
      created: DateTime.tryParse(user["created"]),
      updated: DateTime.tryParse(user["updated"]),
    );
  }
}
