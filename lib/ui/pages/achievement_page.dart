// AchievementPage: 업적 리스트를 표시하는 화면
import 'package:flutter/material.dart';
import 'package:task_spark/data/user.dart';
import 'package:task_spark/data/achievement.dart';
import 'package:task_spark/service/achievement_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AchievementPage extends StatefulWidget {
  final String nickname;
  final num expRate; // 경험치 비율
  final User myUser;

  const AchievementPage({
    super.key,
    required this.nickname,
    required this.expRate,
    required this.myUser,
  });

  static const List<String> tierNames = [
    '없음',
    '브론즈',
    '실버',
    '골드',
    '플래티넘',
    '다이아'
  ];

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  List<Achievement> achievements = [];
  bool isLoading = true;
  Map<String, int> userValues = {};

  // 히든 업적 해금 여부 판단
  bool _userHasUnlocked(Achievement achievement) {
    final currentValue = userValues[achievement.type] ?? 0;
    final requiredValue = achievement.amount.values.first;
    return currentValue >= requiredValue;
  }

  Future<void> _fetchAchiv() async {
    final achivResult = await AchievementService().getAchievementList();
    final userMetaData = await AchievementService().getCurrentMetaData();
    setState(() {
      achievements = achivResult;
      isLoading = false;
      userValues = userMetaData;
    });
  }

  Widget buildProgressSegments(List<int> tierAmounts, int userValue) {
    List<int> thresholds = [0];
    for (var a in tierAmounts) {
      thresholds.add(thresholds.last + a);
    }

    return Row(
      children: List.generate(
        5,
        (i) {
          final start = thresholds[i];
          final end = thresholds[i + 1];

          double segmentProgress;
          if (userValue <= start) {
            segmentProgress = 0.0;
          } else if (userValue >= end) {
            segmentProgress = 1.0;
          } else {
            segmentProgress = (userValue - start) / (end - start);
          }

          return Expanded(
            flex: tierAmounts[i], // 비율에 따라 너비 조절
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getTierColorByIndex(i + 1),
                    borderRadius: i == 0
                        ? const BorderRadius.horizontal(
                            left: Radius.circular(4))
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
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAchiv();
  }

  @override
  Widget build(BuildContext context) {
    final visibleAchievements =
        achievements.where((a) => !a.isHidden || _userHasUnlocked(a)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('업적 리스트',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(
          onPressed: () => Navigator.pop(context, true),
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: visibleAchievements.length,
                    itemBuilder: (context, index) {
                      final achievement = visibleAchievements[index];
                      final int tierIndex = AchievementService()
                          .getCurrentTierIndex(userValues, achievement);
                      double progress = AchievementService()
                          .getProgress(userValues, achievement);
                      final String tierName =
                          AchievementPage.tierNames[tierIndex];

                      if (progress >= 1.0) {
                        progress = 1.0;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 3,
                        color: const Color(0xFF2A241F),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                  tierIndex == 0
                                      ? Icons.lock
                                      : Icons.emoji_events,
                                  size: 40,
                                  color: _getTierColor(tierName)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (tierIndex == 0)
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                      ),
                                    (achievement.isHidden &&
                                                !_userHasUnlocked(
                                                    achievement) ||
                                            tierIndex == 0)
                                        ? const Center(
                                            child: Text(
                                              '???',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            achievement.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                    const SizedBox(height: 4),
                                    (achievement.isHidden &&
                                                !_userHasUnlocked(
                                                    achievement)) ||
                                            tierIndex == 0
                                        ? const Center(
                                            child: Text('해금 전까지 비공개'))
                                        : Text(
                                            achievement.description,
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                    if (tierIndex > 0)
                                      const SizedBox(height: 8),
                                    if (tierIndex == 0)
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4)),
                                    Stack(
                                      children: [
                                        if (tierIndex > 0 &&
                                            !achievement.isOnce)
                                          buildProgressSegments(
                                            achievement.amount.values.toList()
                                              ..sort((a, b) => a.compareTo(b)),
                                            userValues[achievement.type] ?? 0,
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
                                    if (tierIndex > 0)
                                      const SizedBox(height: 4),
                                    if (tierIndex > 0)
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

  //업적 페이지 프로필 바
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: widget.myUser.avatar != null &&
                        widget.myUser.avatar!.isNotEmpty
                    ? NetworkImage(
                        "https://pb.aroxu.me/${widget.myUser.avatar!}")
                    : const AssetImage("assets/images/default_profile.png")
                        as ImageProvider,
              ),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF5BD6FF),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.nickname}님 환영합니다!',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: Colors.orange, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'EXP ${(widget.expRate * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: widget.expRate.toDouble().clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE0E0E0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF5CFF8E),
                  ),
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
      case '없음':
        return Colors.grey.shade300;
      case '브론즈':
        return const Color(0xFFCD7F32); // 브론즈
      case '실버':
        return const Color(0xFFC0C0C0); // 실버
      case '골드':
        return const Color(0xFFFFD700); // 골드
      case '플래티넘':
        return const Color(0xFF88B4C4); // 플래티넘 (Powder Blue)
      case '다이아':
        return const Color(0xFF00FFFF); // 다이아
      default:
        return Colors.grey.shade300;
    }
  }

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
}
