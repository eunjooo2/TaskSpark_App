// achievement_page.dart
// 업적 리스트 페이지 UI 및 로직 처리. 히든 업적은 해금 시 일반 업적처럼 보이고, 해금 전엔 아예 보이지 않음.

import 'package:flutter/material.dart';
import 'package:task_spark/data/user.dart';
import 'package:task_spark/data/achievement.dart';
import 'package:task_spark/service/achievement_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_spark/ui/widgets/achievement_tile.dart';

class AchievementPage extends StatefulWidget {
  final String nickname;
  final num expRate;
  final User myUser;

  const AchievementPage({
    super.key,
    required this.nickname,
    required this.expRate,
    required this.myUser,
  });

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  List<Achievement> achievements = [];
  bool isLoading = true;
  Map<String, int> userValues = {};

  bool _userHasUnlocked(Achievement achievement) {
    final currentValue = userValues[achievement.type] ?? 0;
    // 해금 조건: 해당 업적의 등급 중 하나라도 만족하면 true
    for (final tier in ['bronze', 'silver', 'gold', 'platinum', 'diamond']) {
      final required = achievement.amount[tier];
      if (required != null && currentValue >= required) {
        return true;
      }
    }
    return false;
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

  void _showHintDialog(BuildContext context, Achievement achievement) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.question,
      body: Column(
        children: [
          Text(
            "업적 힌트",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "${achievement.hint}",
                  style: TextStyle(fontSize: 15.sp),
                ),
              ),
              SizedBox(width: 10.w),
            ],
          ),
          SizedBox(height: 3.h),
        ],
      ),
      showCloseIcon: true,
    ).show();
  }

  void _showHelpDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        child: Text(
          '비공개 업적을 누르면 힌트가 보여요!',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
      btnOkText: "확인",
      btnOkOnPress: () {},
    ).show();
  }

  @override
  void initState() {
    super.initState();
    _fetchAchiv();
  }

  @override
  Widget build(BuildContext context) {
    final visibleAchievements = achievements.where((a) {
      if (!a.isHidden) return true;
      return _userHasUnlocked(a); // 히든 업적도 해금됐으면 포함
    }).toList();
    visibleAchievements.sort((a, b) {
      final userValueA = userValues[a.type] ?? 0;
      final userValueB = userValues[b.type] ?? 0;

      int getTierPriority(String tier) =>
          {
            'diamond': 5,
            'platinum': 4,
            'gold': 3,
            'silver': 2,
            'bronze': 1,
            'none': 0,
          }[tier] ??
          0;

      final tierA = AchievementService().getCurrentTierKey(userValueA, a);
      final tierB = AchievementService().getCurrentTierKey(userValueB, b);
      final progressA = AchievementService().getProgress(userValueA, a);
      final progressB = AchievementService().getProgress(userValueB, b);

      //  1. 히든 > 일회성 > 일반
      int priority(Achievement a) {
        if (a.isHidden) return 0;
        if (a.isOnce) return 1;
        return 2;
      }

      final priorityCompare = priority(a).compareTo(priority(b));
      if (priorityCompare != 0) return priorityCompare;

      //  2. 등급 우선순위 비교
      final tierCompare =
          getTierPriority(tierB).compareTo(getTierPriority(tierA));
      if (tierCompare != 0) return tierCompare;

      // 3. 진행률 비교
      final progressCompare = progressB.compareTo(progressA);
      if (progressCompare != 0) return progressCompare;

      //  4. 누적값 비교
      return userValueB.compareTo(userValueA);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('업적 리스트',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(
          onPressed: () => Navigator.pop(context, true),
          color: Theme.of(context).colorScheme.secondary,
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.circleQuestion),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: visibleAchievements.length,
                    itemBuilder: (context, index) {
                      final achievement = visibleAchievements[index];
                      final int userValue = userValues[achievement.type] ?? 0;

                      return AchievementTile(
                        achievement: achievement,
                        currentValue: userValue,
                        isUnlocked: _userHasUnlocked(achievement),
                        onTap: () {
                          if (achievement.isHidden &&
                              !_userHasUnlocked(achievement)) {
                            _showHintDialog(context, achievement);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
