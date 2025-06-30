import 'package:flutter/material.dart';
import 'package:task_spark/data/achievement.dart';
import 'package:task_spark/ui/widgets/achievement_progress_bar.dart';
import 'package:task_spark/util/achievement_utils.dart';

// 업적 객체, 현재 유저 수치, 해금 여부, 탭 이벤트 콜백
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

  // 등급 인덱스에 따라 색상 변환
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
    /// 등급 순서 고정
    final List<String> tierOrder = [
      'bronze',
      'silver',
      'gold',
      'platinum',
      'diamond',
    ];

    /// 각 티어의 필요 수치 추출 (기본값 0으로 설정)
    final List<int> tierAmounts =
        tierOrder.map((t) => achievement.amount[t] ?? 0).toList();

    int tierIndex;
    double progress;

    /// 일회성 업적인 경우: 다이아 티어 조건만 확인
    if (achievement.isOnce) {
      final required = achievement.amount['diamond'] ?? 1; // 다이아 등급에 필요한 수치
      final achieved = currentValue >= required; // 유저가 그 수치 이상이면 T 아니면 F
      tierIndex = achieved ? 5 : 0; // 달성 했으면 5(다이아) 아니면 0
      progress = achieved ? 1.0 : 0.0; // 달성 했으면 1(100%) 아니면 0
    }

    /// 일반 업적인 경우: 현재 등급 인덱스 및 다음 티어 진행률 계산(일회성이랑 로직이 다르기에)
    else {
      tierIndex = getTierIndex(achievement.amount, currentValue);

      if (tierIndex >= 5 || tierIndex >= tierOrder.length - 1) {
        progress = 1.0;
      } else {
        final currentTierKey = tierOrder[tierIndex];
        final nextTierKey = tierOrder[tierIndex + 1];
        final currentRequired = achievement.amount[currentTierKey] ?? 0;
        final nextRequired = achievement.amount[nextTierKey] ?? 0;
        final span = nextRequired - currentRequired;
        final filled = currentValue - currentRequired;
        progress = span > 0 ? (filled / span).clamp(0.0, 1.0) : 0.0;
      }
    }

    /// 한글 등급명 반환
    /// 히든 업적 + 해금 여부 확인
    final tierName = getTierNameKor(tierIndex);
    final isHiddenUnlocked = achievement.isHidden && isUnlocked;
    final isOnceUnlocked = achievement.isOnce && isUnlocked;

    return GestureDetector(
      /// 잠긴 업적만 탭 가능(업적 힌트용)
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
                ? Color.fromARGB(255, 221, 0, 255)
                : _getTierColorByIndex(tierIndex),
            width: tierIndex == 0 ? 0 : 2,
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

                    /// 해금된 경우 제목/설명 보여주고, 아니면 '???' 처리
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
                    // 등급이 있는 경우에만 진행률 바 표시
                    if ((tierIndex > 0 && !achievement.isOnce) ||
                        (achievement.isOnce && tierIndex == 5))
                      AchievementProgressBar(
                        tierAmounts: tierAmounts,
                        userValue: currentValue,
                        isOnce: achievement.isOnce,
                      ),
                    const SizedBox(height: 4),
                    // 진행률 텍스트
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
