// AchievementPage: 업적 리스트를 표시하는 화면
import 'package:flutter/material.dart';
import 'package:task_spark/data/achievement_manager.dart';
import 'package:task_spark/data/user.dart';
import 'package:task_spark/util/pocket_base.dart';
import 'package:task_spark/data/achievement.dart';
import 'package:task_spark/service/achievement_service.dart';

class AchievementPage extends StatefulWidget {
  final Map<String, int> userValues; // 업적 진행 정보
  final String nickname;
  final num expRate; // 경험치 비율
  final User myUser;

  const AchievementPage({
    super.key,
    required this.userValues,
    required this.nickname,
    required this.expRate,
    required this.myUser,
  });

  static const List<String> tierNames = ['브론즈', '실버', '골드', '플래티넘', '다이아'];

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  List<Achievement> achievements = [];
  bool isLoading = true;

  // 히든 업적 해금 여부 판단
  bool _userHasUnlocked(Achievement achievement) {
    final currentValue = widget.userValues[achievement.type] ?? 0;
    final requiredValue = achievement.amount.values.first;
    return currentValue >= requiredValue;
  }

  Future<void> _fetchAchiv() async {
    final achivResult = await AchievementService().getAchievementList();
    setState(() {
      achievements = achivResult;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAchiv();
  }

  @override
  Widget build(BuildContext context) {
    // 히든 업적은 해금 전까지 리스트에 표시되지 않음
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: visibleAchievements.length,
                    itemBuilder: (context, index) {
                      final achievement = visibleAchievements[index];
                      final int userValue =
                          widget.userValues[achievement.type] ?? 0;
                      final int tierIndex =
                          AchievementManager.getCurrentTierIndex(
                              achievement, userValue);
                      final double progress =
                          AchievementManager.getProgressToNextTier(
                              achievement, userValue);
                      final String tierName =
                          AchievementManager.getTierName(tierIndex);

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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 아이콘 (티어 색상 반영)
                              Icon(Icons.emoji_events,
                                  size: 40, color: _getTierColor(tierName)),
                              const SizedBox(width: 12),
                              // 업적 텍스트 정보 영역
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      achievement.isHidden &&
                                              !_userHasUnlocked(achievement)
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
                                              !_userHasUnlocked(achievement)
                                          ? '해금 전까지 비공개'
                                          : achievement.description,
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                    const SizedBox(height: 8),
                                    // 진행률 바
                                    Stack(
                                      children: [
                                        Row(
                                          children: List.generate(5, (i) {
                                            return Expanded(
                                              child: Container(
                                                  height: 8,
                                                  color:
                                                      _getTierColorByIndex(i)),
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

  // 상단 사용자 정보 표시 영역
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: widget.myUser.avatar != null &&
                        widget.myUser.avatar!.isNotEmpty
                    ? NetworkImage(
                        "https://pb.aroxu.me/api/files/${widget.myUser.collectionId}/${widget.myUser.id}/${widget.myUser.avatar}")
                    : const AssetImage("assets/images/default_profile.png")
                        as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 192, 230, 255),
                    shape: BoxShape.circle,
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
                Text(
                  '${widget.nickname}님 환영합니다!',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: Colors.orange, size: 18),
                    const SizedBox(width: 4),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: widget.expRate.toDouble().clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: const Color.fromARGB(255, 234, 255, 235),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 90, 255, 115),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 등급 이름에 따른 색상 반환
  Color _getTierColor(String tier) {
    switch (tier) {
      case '브론즈':
        return Colors.brown;
      case '실버':
        return const Color.fromARGB(255, 153, 153, 153);
      case '골드':
        return const Color.fromARGB(255, 255, 230, 0);
      case '플래티넘':
        return const Color.fromARGB(255, 187, 0, 255);
      case '다이아':
        return const Color.fromARGB(255, 15, 227, 255);
      default:
        return Colors.black26;
    }
  }

  // 인덱스로 등급 색상 반환
  Color _getTierColorByIndex(int index) {
    switch (index) {
      case 0:
        return Colors.brown;
      case 1:
        return const Color.fromARGB(255, 153, 153, 153);
      case 2:
        return const Color.fromARGB(255, 255, 230, 0);
      case 3:
        return const Color.fromARGB(255, 187, 0, 255);
      case 4:
        return const Color.fromARGB(255, 15, 227, 255);
      default:
        return Colors.black26;
    }
  }
}
