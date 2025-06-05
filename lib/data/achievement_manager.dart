/// 업적 달성 여부 판단 및 상태 갱신 로직 + 보상 지급 유틸리티 포함
import 'package:task_spark/utils/models/achievement.dart';
import 'package:task_spark/utils/models/user.dart';

class AchievementManager {
  // 업적 제목 기준으로 해금 여부 저장
  static final Set<String> unlockedTitles = {};

  // 업적 등급 순서
  static const List<String> tierNames = ['브론즈', '실버', '골드', '플래티넘', '다이아'];

  /// 특정 업적들 수동으로 체크해서 해금 처리 (예: 초기 로그인 시 등)
  static void checkAndUnlockAchievements({
    required int taskCount,
    required int routineCount,
    required int loginDays,
    required int blockedFriendCount,
    required List<Achievement> achievements,
  }) {
    for (final achievement in achievements) {
      if (achievement.type == 'make_task') {
        if (taskCount >= achievement.amount['bronze']!) {
          unlockedTitles.add(achievement.title);
        }
      } else if (achievement.type == 'block_friend') {
        if (blockedFriendCount >= achievement.amount['diamond']!) {
          unlockedTitles.add(achievement.title);
        }
      } else if (achievement.type == 'use_nickname_tag_change') {
        unlockedTitles.add(achievement.title);
      }
    }
  }

  /// 전체 업적 기준 현재 유저 수치로 달성 여부 및 티어 판단
  static Map<String, dynamic> checkProgressAndUnlock(
    Map<String, int> userValues,
    List<Achievement> achievements,
  ) {
    final Map<String, Set<String>> unlockedTiers = {}; // 일반 업적
    final Set<String> unlockedOneTime = {}; // 일회성 업적 (히든 포함)

    for (final achievement in achievements) {
      final type = achievement.type;
      final value = userValues[type] ?? 0;

      if (achievement.isOnce) {
        if (value >= (achievement.amount['diamond'] ?? 999999)) {
          unlockedOneTime.add(type);
        }
        continue;
      }

      for (final tier in ['diamond', 'platinum', 'gold', 'silver', 'bronze']) {
        final required = achievement.amount[tier];
        if (required != null && value >= required) {
          unlockedTiers[type] ??= {};
          unlockedTiers[type]!.add(tier);
          break;
        }
      }
    }

    return {
      "tiers": unlockedTiers,
      "oneTime": unlockedOneTime,
    };
  }

  /// 특정 업적 해금 여부
  static bool isUnlocked(Achievement achievement) {
    return unlockedTitles.contains(achievement.title);
  }

  /// 현재 등급 인덱스 반환
  static int getCurrentTierIndex(Achievement achievement, int value) {
    if (achievement.isOnce) {
      return tierNames.indexOf("diamond");
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

  /// 다음 티어까지의 진행률 (0.0 ~ 1.0)
  static double getProgressToNextTier(Achievement achievement, int value) {
    if (achievement.isOnce) return 1.0;

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

  /// 인덱스 기준 등급명 반환
  static String getTierName(int index) {
    if (index < 0 || index >= tierNames.length) return '미달성';
    return tierNames[index];
  }

  /// 특정 업적에서 티어에 맞는 보상 반환
  static Map<String, dynamic>? getRewardForTier(
      Achievement achievement, int tierIndex) {
    String tier = tierNames[tierIndex].toLowerCase();
    return achievement.reward?[tier];
  }
}

/// 보상 지급 유틸리티 (경험치, 아이템)
class RewardProcessor {
  /// 보상 지급: 업적 객체와 등급명 전달 (e.g. 'bronze')
  static void grantReward({
    required Achievement achievement,
    required String tier,
    required User user,
  }) {
    final rewardData = achievement.reward?[tier.toLowerCase()];
    if (rewardData == null) return;

    // 경험치 보상 지급
    if (rewardData.containsKey('exp')) {
      final expAmount = rewardData['exp'] as int;
      user.exp = (user.exp ?? 0) + expAmount;
      print('[보상 지급] 경험치 +$expAmount');
    }

    // 아이템 보상 지급
    if (rewardData.containsKey('items')) {
      final List<dynamic> items = rewardData['items'];
      for (final item in items) {
        final String id = item['id'];
        final int amount = item['amount'];

        user.inventory ??= {};
        final current = user.inventory![id] ?? 0;
        user.inventory![id] = current + amount;

        print('[보상 지급] 아이템 $id x$amount');
      }
    }
  }
}
