import 'package:flutter/material.dart';
import 'package:task_spark/data/achievement_data.dart';
import 'package:task_spark/data/achievement_manager.dart';
import 'package:task_spark/models/achievement.dart';

class AchievementPage extends StatelessWidget {
  final Map<String, int> userValues;
  final String nickname;
  final num exp;

  const AchievementPage({
    super.key,
    required this.userValues,
    required this.nickname,
    required this.exp,
  });

  static const List<String> tierNames = ['브론즈', '실버', '골드', '플래티넘', '다이아'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('업적 리스트',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      body: Column(
        children: [
          _buildTopBar(),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                final int userValue = userValues[achievement.type] ?? 0;
                final int tierIndex = AchievementManager.getCurrentTierIndex(
                    achievement, userValue);
                final double progress =
                    AchievementManager.getProgressToNextTier(
                        achievement, userValue);
                final String tierName =
                    AchievementManager.getTierName(tierIndex);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  color: const Color(0xFF2A241F),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.emoji_events,
                            size: 40, color: _getTierColor(tierName)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                achievement.isHidden &&
                                        !AchievementManager.isUnlocked(
                                            achievement)
                                    ? '???'
                                    : achievement.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                achievement.isHidden &&
                                        !AchievementManager.isUnlocked(
                                            achievement)
                                    ? '해금 전까지 비공개'
                                    : achievement.description,
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              const SizedBox(height: 8),
                              Stack(
                                children: [
                                  Row(
                                    children: List.generate(5, (i) {
                                      return Expanded(
                                        child: Container(
                                          height: 8,
                                          color: _getTierColorByIndex(i)
                                              .withOpacity(0.4),
                                        ),
                                      );
                                    }),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: progress.clamp(0.0, 1.0),
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _getTierColor(tierName),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$tierName 등급 • ${(progress * 100).toInt()}% 진행 중',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage('assets/profile/tiger.png'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '50',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$nickname님 환영합니다!',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: Colors.orange, size: 18),
                    SizedBox(width: 4),
                    Text('1.0x', style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: exp.toDouble(),
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTierColor(String tier) {
    switch (tier) {
      case '브론즈':
        return Colors.brown;
      case '실버':
        return Colors.grey;
      case '골드':
        return Colors.amber;
      case '플래티넘':
        return Colors.blueAccent;
      case '다이아':
        return Colors.cyan;
      default:
        return Colors.black26;
    }
  }

  Color _getTierColorByIndex(int index) {
    switch (index) {
      case 0:
        return Colors.brown;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.amber;
      case 3:
        return Colors.blueAccent;
      case 4:
        return Colors.cyan;
      default:
        return Colors.black26;
    }
  }
}
