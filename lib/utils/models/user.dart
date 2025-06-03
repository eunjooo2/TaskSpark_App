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
  String? nickname;
  String? avatar;
  num? exp;
  int? tag;
  Map<String, dynamic>? inventory;
  DateTime? created;
  DateTime? updated;

  User({
    this.collectionId,
    this.collectionName,
    this.id,
    this.email,
    this.emailVisibility,
    this.verified,
    this.name,
    this.nickname,
    this.avatar,
    this.exp,
    this.tag,
    this.inventory,
    this.created,
    this.updated,
  });

  @override
  String toString() {
    return jsonEncode({
      "collectionId": collectionId,
      "collectionName": collectionName,
      "id": id,
      "nickname": nickname,
      "tag":tag,
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
      nickname: record.data["nickname"] as String?,
      emailVisibility: record.data["emailVisibility"] as bool?,
      verified: record.data["verified"] as bool?,
      name: record.data["name"] as String?,
      avatar: record.data["avatar"] as String?,
      exp: record.data["exp"] as num?,
      tag: record.data["tag"] as int?,
      inventory: record.data["inventory"] as Map<String, dynamic>?,
      created: DateTime.tryParse(record.created),
      updated: DateTime.tryParse(record.updated),
    );
  }
}
