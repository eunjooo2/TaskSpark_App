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
  int? exp;
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
    this.avatar,
    this.exp,
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
      exp: record.data["exp"] as int?,
      inventory: record.data["inventory"] as Map<String, dynamic>?,
      created: DateTime.tryParse(record.created),
      updated: DateTime.tryParse(record.updated),
    );
  }
}
