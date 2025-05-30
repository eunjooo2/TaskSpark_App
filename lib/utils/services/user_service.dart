import '../models/user.dart';
import '../pocket_base.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import '../secure_storage.dart';

class UserService {
  Future<RecordAuth> sendLoginRequest(String provider) async {
    return await PocketB()
        .pocketBase
        .collection("users")
        .authWithOAuth2(provider, (
      url,
    ) async {
      await launchUrl(url);
    });
  }

  Future<User> getUserByID(String userID) async {
    final accessToken = await SecureStorage().storage.read(key: "accessToken");
    final response = await PocketB().pocketBase.send("/user",
        method: "GET",
        query: {"cid": userID},
        headers: {"Authorization": "Bearer $accessToken"});
    return User.fromJson(response);
  }

  Future<SearchData> getUserByNickanemAndTag(String nickname, int? tag) async {
    final accessToken = await SecureStorage().storage.read(key: "accessToken");
    Map<String, dynamic> query = {"nickname": nickname};
    if (tag != null) {
      query["tag"] = tag;
    }

    final response = await PocketB().pocketBase.send("/user/search",
        method: "GET",
        query: query,
        headers: {"Authorization": "Bearer $accessToken"});

    return SearchData.fromJson(response);
  }

  Future<RecordModel> _updateRecordByID(
    String userID,
    Map<String, dynamic> body,
  ) async {
    return await PocketB()
        .pocketBase
        .collection("users")
        .update(userID, body: body);
  }

  Future<User> updateUserByID(String userID, Map<String, dynamic> body) async {
    return User.fromRecord(await _updateRecordByID(userID, body));
  }

  Future<void> deleteUserByID(String userID) async {
    return await PocketB().pocketBase.collection("users").delete(userID);
  }
}
