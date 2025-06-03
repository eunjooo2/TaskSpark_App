// 사용자 업적 보관
import 'package:pocketbase/pocketbase.dart';

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? avatar;

  final String? nickname;
  final int? level;
  final double? expRate;
  final double? expMultiplier; // 경험치 부스터

  final String? collectionId;

  User({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.nickname,
    this.level,
    this.expRate,
    this.expMultiplier,
    this.collectionId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      nickname: json['nickname'],
      level: json['level'],
      expRate: (json['expRate'] as num?)?.toDouble(),
      expMultiplier: (json['expMultiplier'] as num?)?.toDouble(),
      collectionId: json['collectionId'],
    );
  }

  factory User.fromRecord(RecordModel record) {
    final data = record.data;
    return User(
      id: record.id,
      name: data['name'],
      email: data['email'],
      avatar: data['avatar'],
      nickname: data['nickname'],
      level: data['level'],
      expRate: (data['expRate'] as num?)?.toDouble(),
      expMultiplier: (data['expMultiplier'] as num?)?.toDouble(),
      collectionId: record.collectionId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'nickname': nickname,
      'level': level,
      'expRate': expRate,
      'expMultiplier': expMultiplier,
      'collectionId': collectionId,
    };
  }
}
