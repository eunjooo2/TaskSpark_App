import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/user.dart';

class PocketB {
  static final PocketB _instance = PocketB._internal();
  late final PocketBase pocketBase;

  factory PocketB() => _instance;

  PocketB._internal() {
    pocketBase = PocketBase("https://pb.aroxu.me");
  }

  Future<RecordAuth> sendLoginRequest(String provider) async {
    return await pocketBase.collection("users").authWithOAuth2(
      provider,
          (url) async => await launchUrl(url),
    );
  }

  Future<RecordModel> _getRecordByID(String userId) async {
    return await pocketBase.collection("users").getOne(userId);
  }

  Future<User> getUserByID(String userId) async {
    final record = await _getRecordByID(userId);
    return User.fromRecord(record);
  }

  Future<RecordModel> _updateRecordByID(String userId, Map<String, dynamic> data) async {
    return await pocketBase.collection("users").update(userId, body: data);
  }

  Future<User> updateUserByID(String userId, Map<String, dynamic> data) async {
    final record = await _updateRecordByID(userId, data);
    return User.fromRecord(record);
  }

  Future<void> deleteUserByID(String userId) async {
    await pocketBase.collection("users").delete(userId);
  }
}
