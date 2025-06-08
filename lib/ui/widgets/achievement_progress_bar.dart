import 'package:flutter/material.dart';

class AchievementProgressBar extends StatelessWidget {
  final List<int> tierAmounts;
  final int userValue;
  final bool isOnce;

  const AchievementProgressBar({
    super.key,
    required this.tierAmounts,
    required this.userValue,
    this.isOnce = false,
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

    if (isOnce) {
      final bool isCompleted = userValue > 0;
      return Container(
        height: 8,
        decoration: BoxDecoration(
          color: lightColors.last,
          borderRadius: BorderRadius.circular(4),
        ),
        child: FractionallySizedBox(
          widthFactor: isCompleted ? 1.0 : 0.0,
          child: Container(
            decoration: BoxDecoration(
              color: strongColors.last,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );
    }

    // 일반 업적
    final List<int> thresholds = [0];
    for (final amount in tierAmounts) {
      thresholds.add(thresholds.last + amount);
    }

    return Row(
      children: List.generate(5, (i) {
        final int start = thresholds[i];
        final int end = thresholds[i + 1];
        double segmentProgress = 0.0;

        if (userValue <= start) {
          segmentProgress = 0.0;
        } else if (userValue >= end) {
          segmentProgress = 1.0;
        } else {
          segmentProgress = (userValue - start) / (end - start);
        }

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
                      : i == 4
                          ? const BorderRadius.horizontal(
                              right: Radius.circular(4))
                          : BorderRadius.zero,
                ),
              ),
              FractionallySizedBox(
                widthFactor: segmentProgress.clamp(0.0, 1.0),
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
