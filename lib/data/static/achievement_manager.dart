import '../achievement.dart';
import 'achievement_data.dart';

// 해금된 업적 저장

class AchievementManager {
  static final Set<String> unlockedTitles = {};

  // 업적 해금 체크 함수
  static void checkAndUnlockAchievements({
    required int taskCount,
    required int routineCount,
    required int loginDays,
    required int blockedFriendCount, // 차단업적을 위한 매개변수
  }) {
    for (final achievement in achievements) {
      if (achievement.type == 'make_task') {
        if (taskCount >= achievement.amount['bronze']!) {
          unlockedTitles.add(achievement.title);
        }
      }

      // 👇 차단 업적 조건 추가
      else if (achievement.type == 'block_friend') {
        if (blockedFriendCount >= achievement.amount['bronze']!) {
          unlockedTitles.add(achievement.title);
        }
      }
    }
  }

  static bool isUnlocked(Achievement achievement) {
    return unlockedTitles.contains(achievement.title);
  }
}
