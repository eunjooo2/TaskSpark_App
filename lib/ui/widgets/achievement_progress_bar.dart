// achievement_progress_bar.dart
// 업적 등급별 색상 구간별로 진행률을 나눠서 표현하는 커스텀 게이지바 위젯
// currentProgress는 현재 등급 구간에서의 진행률 (0.0~1.0)

import 'package:flutter/material.dart';

class AchievementProgressBar extends StatelessWidget {
  final int currentTierIndex; // 1부터 시작하는 등급 인덱스 (0은 등급 없음)
  final double currentProgress; // 현재 등급에서의 진행률 (0.0 ~ 1.0)
  final int totalTiers; // 등급 총 개수 (보통 5)

  const AchievementProgressBar({
    super.key,
    required this.currentTierIndex,
    required this.currentProgress,
    this.totalTiers = 5,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> strongColors = [
      const Color(0xFFCD7F32), // 브론즈
      const Color(0xFFC0C0C0), // 실버
      const Color(0xFFFFD700), // 골드
      const Color(0xFF88B4C4), // 플래티넘
      const Color(0xFF00FFFF), // 다이아
    ];

    final List<Color> lightColors = [
      const Color.fromARGB(255, 227, 197, 169),
      const Color(0xFFE6E6E6),
      const Color.fromARGB(255, 255, 239, 191),
      const Color.fromARGB(255, 205, 222, 228),
      const Color.fromARGB(255, 201, 255, 255),
    ];

    final int adjustedTierIndex =
        (currentTierIndex - 1).clamp(0, totalTiers - 1);

    return Row(
      children: List.generate(totalTiers, (i) {
        return Expanded(
          flex: 1,
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: lightColors[i],
                  borderRadius: i == 0
                      ? const BorderRadius.horizontal(left: Radius.circular(4))
                      : i == totalTiers - 1
                          ? const BorderRadius.horizontal(
                              right: Radius.circular(4))
                          : BorderRadius.zero,
                ),
              ),
              if (i < adjustedTierIndex)
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: strongColors[i],
                    borderRadius: i == 0
                        ? const BorderRadius.horizontal(
                            left: Radius.circular(4))
                        : i == totalTiers - 1
                            ? const BorderRadius.horizontal(
                                right: Radius.circular(4))
                            : BorderRadius.zero,
                  ),
                )
              else if (i == adjustedTierIndex)
                FractionallySizedBox(
                  widthFactor: currentProgress.clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: strongColors[i],
                      borderRadius: i == 0
                          ? const BorderRadius.horizontal(
                              left: Radius.circular(4))
                          : i == totalTiers - 1
                              ? const BorderRadius.horizontal(
                                  right: Radius.circular(4))
                              : BorderRadius.zero,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
