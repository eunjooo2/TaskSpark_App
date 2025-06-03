// 업적 달성 여부 판단 및 상태 갱신 로직 포함
import 'package:task_spark/models/achievement.dart';
import 'achievement_data.dart';

class AchievementManager {
  static final Set<String> unlockedTitles = {};

  static const List<String> tierNames = ['브론즈', '실버', '골드', '플래티넘', '다이아'];

  static void checkAndUnlockAchievements({
    required int taskCount,
    required int routineCount,
    required int loginDays,
    required int blockedFriendCount,
  }) {
    for (final achievement in achievements) {
      if (achievement.type == 'make_task') {
        if (taskCount >= achievement.amount['bronze']!) {
          unlockedTitles.add(achievement.title);
        }
      } else if (achievement.type == 'block_friend') {
        if (blockedFriendCount >= achievement.amount['bronze']!) {
          unlockedTitles.add(achievement.title);
        }
      }
    }
  }

  static bool isUnlocked(Achievement achievement) {
    return unlockedTitles.contains(achievement.title);
  }

  static int getCurrentTierIndex(Achievement achievement, int value) {
    if (achievement.forceTier != null) {
      return tierNames.indexOf(achievement.forceTier!);
    }

    int index = -1;
    for (int i = 0; i < tierNames.length; i++) {
      final tier = tierNames[i];
      final required = achievement.amount[tier.toLowerCase()];
      if (required != null && value >= required) {
        index = i;
      }
    }
    return index;
  }

  static double getProgressToNextTier(Achievement achievement, int value) {
    if (achievement.forceTier != null || achievement.isOneTime) return 1.0;

    int currentTier = getCurrentTierIndex(achievement, value);
    int nextTier = currentTier + 1;

    if (nextTier >= tierNames.length) return 1.0;

    int? currentRequired = currentTier >= 0
        ? achievement.amount[tierNames[currentTier].toLowerCase()]
        : 0;

    int? nextRequired = achievement.amount[tierNames[nextTier].toLowerCase()];

    if (nextRequired == null) return 1.0;

    return ((value - (currentRequired ?? 0)) /
            (nextRequired - (currentRequired ?? 0)))
        .clamp(0.0, 1.0);
  }

  static String getTierName(int index) {
    if (index < 0 || index >= tierNames.length) return '미달성';
    return tierNames[index];
  }

  static Map<String, dynamic>? getRewardForTier(
      Achievement achievement, int tierIndex) {
    String tier = tierNames[tierIndex].toLowerCase();
    return achievement.reward?[tier];
  }
}
