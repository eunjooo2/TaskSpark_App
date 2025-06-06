import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:task_spark/data/friend.dart';

import '../data/user.dart';
import '../util/pocket_base.dart';
import '../util/secure_storage.dart';

class UserService {
  final PocketBase _pb = PocketB().pocketBase;

  /// OAuth2 로그인 요청 (provider: 'google', 'github' 등)
  Future<RecordAuth> sendLoginRequest(String provider) async {
    return await _pb.collection("users").authWithOAuth2(
          provider,
          (url) async => await launchUrl(url),
        );
  }

  /// 사용자 ID로 유저 정보 조회
  Future<User> getUserByID(String userId) async {
    final token = await SecureStorage().storage.read(key: "accessToken");

    final response = await _pb.send(
      "/user",
      method: "GET",
      query: {"cid": userId},
      headers: {"Authorization": "Bearer $token"},
    );

    return User.fromJson(response);
  }

  Future<User> getProfile() async {
    final userID = await SecureStorage().storage.read(key: "userID") ?? "";

    return User.fromRecord(
        await PocketB().pocketBase.collection("users").getOne(userID));
  }

  /// 닉네임과 태그로 사용자 검색
  Future<SearchData> getUserByNicknameAndTag(String nickname, int? tag) async {
    final token = await SecureStorage().storage.read(key: "accessToken");

    final query = {
      "nickname": nickname,
      if (tag != null) "tag": tag,
    };

    final response = await _pb.send(
      "/user/search",
      method: "GET",
      query: query,
      headers: {"Authorization": "Bearer $token"},
    );

    return SearchData.fromJson(response);
  }

  /// 사용자 정보 업데이트
  Future<User> updateUserByID(String userId, Map<String, dynamic> data) async {
    final record = await _pb.collection("users").update(userId, body: data);
    return User.fromRecord(record);
  }

  /// 사용자 삭제
  Future<void> deleteUserByID(String userId) async {
    await _pb.collection("users").delete(userId);
  }

  /// 경험치 지급
  Future<void> grantExperienceToUser(int amount) async {
    try {
      final userId = await SecureStorage().storage.read(key: "userID");
      final record = await _pb.collection("users").getOne(userId!);
      final currentExp = record.get<int>("exp");

      await _pb.collection("users").update(userId, body: {
        "exp": currentExp + amount,
      });

      print("경험치 $amount 지급 완료 (총 XP: ${currentExp + amount})");
    } catch (e) {
      print("경험치 지급 실패: $e");
    }
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
