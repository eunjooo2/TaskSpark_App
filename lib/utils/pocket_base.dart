import 'package:pocketbase/pocketbase.dart';
import 'package:task_spark/utils/models/friend.dart';
import 'package:task_spark/utils/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class PocketB {
  static final PocketB _instance = PocketB._internal();
  late PocketBase pocketBase;

  factory PocketB() {
    return _instance;
  }

  PocketB._internal() {
    pocketBase = PocketBase("https://pb.aroxu.me");
  }

  Future<RecordAuth> sendLoginRequest(String provider) async {
    return await pocketBase.collection("users").authWithOAuth2(provider, (
      url,
    ) async {
      await launchUrl(url);
    });
  }

  Future<RecordModel> _getRecordByID(String userID) async {
    return await pocketBase.collection("users").getOne(userID);
  }

  Future<User> getUserByID(String userID) async {
    return User.fromRecord(await _getRecordByID(userID));
  }

  Future<RecordModel> _updateRecordByID(
    String userID,
    Map<String, dynamic> body,
  ) async {
    return await pocketBase.collection("users").update(userID, body: body);
  }

  Future<User> updateUserByID(String userID, Map<String, dynamic> body) async {
    return User.fromRecord(await _updateRecordByID(userID, body));
  }

  Future<void> deleteUserByID(String userID) async {
    return await pocketBase.collection("users").delete(userID);
  }

  Future<RecordModel> getFriendList() async {
    return await pocketBase.collection("friends").getFullList(
      filter: 
    )
  }
}
