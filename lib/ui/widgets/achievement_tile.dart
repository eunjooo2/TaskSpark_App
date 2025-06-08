// achievement_tile.dart
// 업적 하나를 리스트에 보여주는 UI 컴포넌트.
// 트로피 아이콘, 등급, 설명, 진행률, 게이지바 포함.
// 잠긴 업적은 ???로 표시하며, 터치 시 힌트 다이얼로그 호출 콜백 가능.

import 'package:flutter/material.dart';
import 'package:task_spark/data/achievement.dart';
import 'package:task_spark/ui/widgets/achievement_progress_bar.dart';
import 'package:task_spark/util/achievement_utils.dart';

class AchievementTile extends StatelessWidget {
  final Achievement achievement;
  final int currentValue;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const AchievementTile({
    super.key,
    required this.achievement,
    required this.currentValue,
    required this.isUnlocked,
    this.onTap,
  });

  Color _getTierColorByIndex(int index) {
    switch (index) {
      case 1:
        return const Color(0xFFCD7F32); // 브론즈
      case 2:
        return const Color(0xFFC0C0C0); // 실버
      case 3:
        return const Color(0xFFFFD700); // 골드
      case 4:
        return const Color(0xFF88B4C4); // 플래티넘
      case 5:
        return const Color(0xFF00FFFF); // 다이아
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    int tierIndex;
    double progress;

    if (achievement.isOnce) {
      final required = achievement.amount['diamond'] ?? 1;
      final achieved = currentValue >= required;
      tierIndex = achieved ? 5 : 0;
      progress = achieved ? 1.0 : 0.0;
    } else {
      tierIndex = getTierIndex(achievement.amount, currentValue);
      progress =
          getProgressPercent(currentValue, achievement.amount, tierIndex);
    }

    final tierName = getTierNameKor(tierIndex);
    final isHiddenUnlocked = achievement.isHidden && isUnlocked;
    final isOnceUnlocked = achievement.isOnce && isUnlocked;

    return GestureDetector(
      onTap: () {
        if (!isUnlocked && onTap != null) {
          onTap!();
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isHiddenUnlocked
                ? Colors.cyanAccent
                : isOnceUnlocked
                    ? Colors.purpleAccent
                    : Colors.transparent,
            width: 2,
          ),
        ),
        elevation: 3,
        color: const Color.fromARGB(255, 72, 63, 55),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                tierIndex == 0 ? Icons.lock : Icons.emoji_events,
                size: 40,
                color: _getTierColorByIndex(tierIndex),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    isUnlocked || (achievement.isOnce && tierIndex == 5)
                        ? Text(
                            achievement.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : const Center(
                            child: Text(
                              '???',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                    const SizedBox(height: 4),
                    isUnlocked || (achievement.isOnce && tierIndex == 5)
                        ? Text(
                            achievement.description,
                            style: TextStyle(color: Colors.grey[400]),
                          )
                        : const Center(child: Text('해금 전까지 비공개')),
                    const SizedBox(height: 8),
                    if ((tierIndex > 0 && !achievement.isOnce) ||
                        (achievement.isOnce && tierIndex == 5))
                      AchievementProgressBar(
                        currentTierIndex: tierIndex,
                        currentProgress: progress,
                      ),
                    const SizedBox(height: 4),
                    if (isUnlocked || (achievement.isOnce && tierIndex == 5))
                      Text(
                        '$tierName 등급 • ${(progress * 100).toInt()}% 진행 중',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
