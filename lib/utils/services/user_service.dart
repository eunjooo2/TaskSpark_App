import '../models/user.dart';
import '../pocket_base.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import '../secure_storage.dart';
import '../models/friend.dart';

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

  Future<String> getOtherUserID(FriendRequest request) async {
    String? myUserID = await SecureStorage().storage.read(key: "userID");
    if (request.senderId == myUserID) {
      return request.receiverId;
    } else {
      return request.senderId;
    }
  }

  int convertExpToLevel(num exp) {
    int low = 0;
    int high = 1000; // 현실적으로 도달할 수 있는 최대 레벨 설정

    while (low <= high) {
      int mid = (low + high) ~/ 2;
      int requiredExp = 50 * mid * mid + 100 * mid;

      if (requiredExp == exp) {
        return mid;
      } else if (requiredExp < exp) {
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    return high;
  }

  int experienceToNextLevel(int exp) {
    int level = convertExpToLevel(exp);
    int nextLevelExp = 50 * (level + 1) * (level + 1) + 100 * (level + 1);
    return nextLevelExp - exp;
  }
}
