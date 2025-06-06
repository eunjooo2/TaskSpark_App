import 'package:task_spark/data/achievement.dart';
import 'package:task_spark/util/pocket_base.dart';

class AchievementService {
  Future<List<Achievement>> getAchievementList() async {
    return (await PocketB()
            .pocketBase
            .collection("achievement")
            .getFullList(filter: "isHidden=false"))
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

  Future<void> upsertUserAchievement({
    required String userId,
    required String achievementId,
    required String type,
    required int valueToAdd,
  }) async {
    final pb = PocketB().pocketBase;

    // 기존 문서 존재 여부 확인 dd
    final existing = await pb
        .collection('user_achievement')
        .getFirstListItem(
          'user.id="$userId" && achievement.id="$achievementId"',
          expand: 'achievement',
        )
        .catchError((e) => null); // 없을 경우 null 반환

    if (existing == null) {
      // 없으면 새로 생성
      await pb.collection('user_achievement').create(body: {
        "user": userId,
        "achievement": achievementId,
        "tier": "no_tier",
        "isCompleted": false,
        "isHidden": false,
        "metadata": {
          "type": type,
          "currentValue": valueToAdd,
        },
      });

      print('[업적 생성] $type → +$valueToAdd');
    } else {
      // 있으면 기존 metadata 값 업데이트
      final metadata =
          Map<String, dynamic>.from(existing.data["metadata"] ?? {});
      final prevValue = metadata["currentValue"] ?? 0;
      final newValue = prevValue + valueToAdd;

      metadata["currentValue"] = newValue;

      await pb.collection('user_achievement').update(
        existing.id,
        body: {
          "metadata": metadata,
        },
      );

      print('[업적 갱신] $type: $prevValue → $newValue');
    }
  }
}
