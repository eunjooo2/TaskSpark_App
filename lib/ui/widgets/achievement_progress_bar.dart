import 'package:flutter/material.dart';

/// 업적 진행률을 나타내는 커스텀 게이지바
class AchievementProgressBar extends StatelessWidget {
  final List<int> tierAmounts; // 각 티어별 필요 수치 (예: [5, 10, 15, 20, 30])
  final int userValue; // 유저가 현재 달성한 수치 (예: 23)
  final bool isOnce; // 일회성 업적인지 여부

  const AchievementProgressBar({
    super.key,
    required this.tierAmounts,
    required this.userValue,
    this.isOnce = false,
  });

  @override
  Widget build(BuildContext context) {
    // 진한 색상 (실제 진행률을 나타낼 때 사용)
    final List<Color> strongColors = [
      const Color(0xFFCD7F32), // 브론즈
      const Color(0xFFC0C0C0), // 실버
      const Color(0xFFFFD700), // 골드
      const Color(0xFF88B4C4), // 플래티넘
      const Color(0xFF00FFFF), // 다이아
    ];

    // 연한 색상 (게이지 배경 색)
    final List<Color> lightColors = [
      const Color.fromARGB(255, 227, 197, 169),
      const Color(0xFFE6E6E6),
      const Color.fromARGB(255, 255, 239, 191),
      const Color.fromARGB(255, 205, 222, 228),
      const Color.fromARGB(255, 201, 255, 255),
    ];

    /// 일회성 업적인 경우
    if (isOnce) {
      final bool isCompleted = userValue > 0;

      // 100% 또는 0% 진행률 게이지 단일로 표시
      return Container(
        height: 8,
        decoration: BoxDecoration(
          color: lightColors.last, // 배경: 다이아 연한색
          borderRadius: BorderRadius.circular(4),
        ),
        child: FractionallySizedBox(
          widthFactor: isCompleted ? 1.0 : 0.0, // 100% 또는 0%만 표시
          child: Container(
            decoration: BoxDecoration(
              color: strongColors.last, // 진행 색: 다이아 진한색
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );
    }

    /// 일반 업적인 경우

    // 누적 티어 기준 수치 계산 (예: [0, 5, 15, 30, 50, 80])
    final List<int> thresholds = [0];
    for (final amount in tierAmounts) {
      thresholds.add(thresholds.last + amount);
    }

    // 각 티어(5단계)마다 게이지 하나씩 생성
    return Row(
      children: List.generate(5, (i) {
        final int start = thresholds[i]; // 현재 티어 시작 기준
        final int end = thresholds[i + 1]; // 다음 티어 도달 기준
        double segmentProgress = 0.0;

        // 유저 수치에 따라 현재 티어의 진행률 계산
        if (userValue <= start) {
          segmentProgress = 0.0; // 시작 기준 미달
        } else if (userValue >= end) {
          segmentProgress = 1.0; // 다음 티어 도달 완료
        } else {
          segmentProgress = (userValue - start) / (end - start); // 진행 중 비율
        }

        return Expanded(
          flex: 1, // 동일 너비로 5등분
          child: Stack(
            children: [
              // 연한 배경 게이지
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: lightColors[i],
                  borderRadius: i == 0
                      ? const BorderRadius.horizontal(left: Radius.circular(4))
                      : i == 4
                          ? const BorderRadius.horizontal(
                              right: Radius.circular(4))
                          : BorderRadius.zero,
                ),
              ),

              // 채워진 진행률 부분 (진한 색)
              FractionallySizedBox(
                widthFactor: segmentProgress.clamp(0.0, 1.0), // 0.0~1.0 사이 제한
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: strongColors[i],
                    borderRadius: i == 0
                        ? const BorderRadius.horizontal(
                            left: Radius.circular(4))
                        : i == 4
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
