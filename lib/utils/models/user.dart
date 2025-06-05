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
  int? level;
  double? expRate; // 경험치 비율
  double? expMultiplier; // 경험치 부스터
  int maxExp;
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
    this.level,
    this.inventory,
    this.created,
    this.updated,
    this.expRate,
    this.expMultiplier,
    this.maxExp = 50000,
  });

  @override
  String toString() {
    return jsonEncode({
      "collectionId": collectionId,
      "collectionName": collectionName,
      "id": id,
      "nickname": nickname,
      "tag": tag,
      "level": level,
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
      level: record.data["level"] as int?, //
      inventory: record.data["inventory"] as Map<String, dynamic>?,
      created: DateTime.tryParse(record.created),
      updated: DateTime.tryParse(record.updated),
      expRate: (record.data["expRate"] as num?)?.toDouble(),
      expMultiplier: (record.data["expMultiplier"] as num?)?.toDouble(),
      maxExp: record.data["maxExp"] ?? 50000,
    );
  }
}

// 경험치 비율
extension UserExpExtensions on User {
  // 최대 경험치 = 현재 레벨(level) × 1000
  int get calculatedMaxExp => (level ?? 1) * 1000;

  // 경험치 비율 (0.0 ~ 1.0)
  double get calculatedExpRate => (exp ?? 0) / calculatedMaxExp;

  // "현재 / 최대" 형식
  String get expProgressText =>
      "${(exp ?? 0).toInt()} / ${calculatedMaxExp.toInt()}";
}
