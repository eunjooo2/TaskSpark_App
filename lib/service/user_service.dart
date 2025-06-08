import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:task_spark/data/friend.dart';
import 'package:task_spark/data/user.dart';
import '../util/pocket_base.dart';
import '../util/secure_storage.dart';
import 'package:task_spark/service/achievement_service.dart'; //  업적 연동용
import 'package:intl/intl.dart';

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

  /// 현재 로그인된 사용자 프로필 조회
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

    // 닉네임 또는 태그 변경 감지 (업적 연동)
    if (data.containsKey("nickname") || data.containsKey("tag")) {
      await AchievementService()
          .updateMetaDataWithKey("use_nickname_tag_change", 1);
      print("✨ 닉네임/태그 변경 업적 +1");
    }

    return User.fromRecord(record);
  }

  /// 사용자 삭제
  Future<void> deleteUserByID(String userId) async {
    await _pb.collection("users").delete(userId);
  }

  /// # 경험치 지급 + metadata 갱신 + 레벨업 업적 연동
  Future<void> grantExperienceToUser(int amount) async {
    try {
      final userId = await SecureStorage().storage.read(key: "userID");
      final record = await _pb.collection("users").getOne(userId!);

      final currentExp = record.get<int>("exp");
      final currentLevel = record.get<int>("level") ?? 1;
      final metadata = Map<String, dynamic>.from(record.data['metadata'] ?? {});

      final newExp = currentExp + amount;
      final newLevel = convertExpToLevel(newExp);

      metadata['exp'] = newExp;
      metadata['level'] = newLevel;

      await _pb.collection("users").update(userId, body: {
        "exp": newExp,
        "metadata": metadata,
      });

      print("경험치 $amount 지급 완료 (총 XP: $newExp, 레벨: $newLevel)");

      // ✅ 레벨 업 업적 반영
      if (newLevel > currentLevel) {
        await AchievementService().updateMetaDataWithKey("level_up", 1);
        print("🎉 레벨 업! level_up 업적 +1");
      }
    } catch (e) {
      print("경험치 지급 실패: $e");
    }
  }

  /// # 유저 객체에 exp/level 반영 후 서버에 업데이트 + 업적 연동
  Future<void> updateExpAndLevel(User user) async {
    final exp = user.exp ?? 0;
    final prevLevel = user.metadata?['level'] ?? 1;
    final newLevel = convertExpToLevel(exp);

    user.metadata ??= {};
    user.metadata!['exp'] = exp;
    user.metadata!['level'] = newLevel;

    try {
      await _pb.collection("users").update(user.id!, body: {
        "exp": exp,
        "metadata": user.metadata,
      });

      print("업데이트 완료: exp=$exp, level=$newLevel");

      // ✅ 레벨 업 업적 반영
      if (newLevel > prevLevel) {
        await AchievementService().updateMetaDataWithKey("level_up", 1);
        print("🎉 레벨 업! level_up 업적 +1");
      }
    } catch (e) {
      print("업데이트 실패: $e");
    }
  }

  /// 친구 요청 내/상대 ID 구분
  Future<String> getOtherUserID(FriendRequest request) async {
    String? myUserID = await SecureStorage().storage.read(key: "userID");
    if (request.senderId == myUserID) {
      return request.receiverId;
    } else {
      return request.senderId;
    }
  }

  /// 경험치 → 레벨 변환 함수
  int convertExpToLevel(num exp) {
    int low = 0;
    int high = 1000;

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

  /// 다음 레벨까지 남은 경험치
  int experienceToNextLevel(int exp) {
    int level = convertExpToLevel(exp);
    int nextLevelExp = 50 * (level + 1) * (level + 1) + 100 * (level + 1);
    return nextLevelExp - exp;
  }

  /// 로그인 연속 스트릭 처리
  Future<void> updateLoginStreak(User user) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final yesterday = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));

    final streak = user.metadata?["loginStreak"] ?? {};
    final lastDate = streak["lastDate"];
    int count = streak["count"] ?? 0;

    if (lastDate == today) {
      // 오늘 이미 처리됨
      return;
    } else if (lastDate == yesterday) {
      count += 1;
    } else {
      count = 1;
    }

    user.metadata!["loginStreak"] = {
      "lastDate": today,
      "count": count,
    };

    await _pb.collection("users").update(user.id!, body: {
      "metadata": user.metadata,
    });

    await AchievementService().updateMetaDataWithKey("login_streak", count);
    print("📅 로그인 스트릭 +$count");
  }
}
