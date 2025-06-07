import 'package:task_spark/data/achievement.dart';
import 'package:task_spark/service/user_service.dart';
import 'package:task_spark/util/pocket_base.dart';

class AchievementService {
  Future<List<Achievement>> getAchievementList() async {
    return (await PocketB().pocketBase.collection("achievement").getFullList())
        .map((e) => Achievement.fromRecord(e))
        .toList();
  }

  Future<Map<String, int>> getUserValues(String userId) async {
    final result =
        await PocketB().pocketBase.collection('user_achievement').getFullList(
              filter: 'user.id="$userId"',
              expand: 'achievement',
            );
    final Map<String, int> userValues = {};

    for (final record in result) {
      final metadata = record.data['metadata'] as Map<String, dynamic>?;

      if (metadata == null) continue;

      final String? type = metadata['type'];
      final int? currentValue = metadata['currentValue'];

      if (type == null || currentValue == null) continue;

      userValues[type] = currentValue > (userValues[type] ?? 0)
          ? currentValue
          : userValues[type]!;
    }

    return userValues;
  }

  Future<List<String>> getAchieType() async {
    return (await getAchievementList()).map((e) => e.type).toList();
  }

  Future<void> updateMetaDataWithKey(String key, int value) async {
    final user = await UserService().getProfile();
    final achievements = user.metadata?["achievements"];

    if (achievements != null) {
      achievements[key] = achievements[key] + 1;

      user.metadata?['achievements'] = achievements;
    }

    await PocketB().pocketBase.collection("users").update(user.id ?? "", body: {
      "metadata": user.metadata,
    });
  }

  Future<Map<String, int>> getCurrentMetaData() async {
    final user = await UserService().getProfile();

    final dynamic rawAchievements = user.metadata?["achievements"];
    return Map<String, int>.from(rawAchievements);
  }

  int getCurrentTierIndex(
      Map<String, int> userValues, Achievement achievement) {
    final currentValue = userValues[achievement.type] ?? 0;
    final bronzeValue = achievement.amount["bronze"] ?? 0;
    final silverValue = achievement.amount["silver"] ?? 0;
    final goldValue = achievement.amount["gold"] ?? 0;
    final platinumValue = achievement.amount["platinum"] ?? 0;
    final diamondValue = achievement.amount["diamond"] ?? 0;

    if (achievement.isOnce == true) {
      if (currentValue <= diamondValue) {
        return 0;
      } else {
        return 5;
      }
    }

    if (currentValue < bronzeValue) {
      return 0;
    } else if (currentValue < silverValue) {
      return 1; // hehe
    } else if (currentValue < goldValue) {
      return 2;
    } else if (currentValue < platinumValue) {
      return 3;
    } else if (currentValue < diamondValue) {
      return 4;
    } else {
      return 5;
    }
  }

  double getProgress(Map<String, int> userValues, Achievement achievement) {
    final currentValue = userValues[achievement.type] ?? 0;
    if (achievement.isOnce == true) {
      if (currentValue >= achievement.amount["diamond"]!) {
        return 1.0;
      } else {
        return 0;
      }
    }
    return (double.parse(currentValue.toString()) -
            achievement.amount["bronze"]!) /
        achievement.amount["diamond"]!;
  }
}
