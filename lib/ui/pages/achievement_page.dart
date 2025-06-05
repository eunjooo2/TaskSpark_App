import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../data/static/achievement_data.dart';

class ArchievePage extends StatefulWidget {
  const ArchievePage({super.key});

  @override
  State<ArchievePage> createState() => _ArchievePageState();
}

class _ArchievePageState extends State<ArchievePage> {
  final int unlockedCount = 5;

  String getCurrentTier(int unlockedCount) {
    if (unlockedCount < 5) return "bronze";
    if (unlockedCount < 15) return "silver";
    if (unlockedCount < 30) return "gold";
    if (unlockedCount < 50) return "platinum";
    return "diamond";
  }

  bool isTierUnlocked(int index, int unlockedCount) {
    if (unlockedCount < 5) return index < 5;
    if (unlockedCount < 15) return index < 15;
    if (unlockedCount < 30) return index < 30;
    if (unlockedCount < 50) return index < 50;
    return true;
  }

  Color getMedalColor(String tier, bool isUnlocked) {
    if (!isUnlocked) return Colors.grey;
    switch (tier) {
      case "bronze":
        return const Color.fromARGB(255, 173, 109, 44);
      case "silver":
        return const Color.fromARGB(255, 184, 184, 184);
      case "gold":
        return const Color(0xFFFD7D0D);
      case "platinum":
        return const Color(0xFF00FFFF);
      case "diamond":
        return const Color(0xFF6A5ACD);
      default:
        debugPrint("알 수 없는 tier: $tier");
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTier = getCurrentTier(unlockedCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text("업적"),
      ),
      body: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 10),
          _buildMedalGrid(currentTier),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.deepOrange,
                    width: 2,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/default_profile.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Text("35", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                    "디스커버즈님 환영합니다!",
                    style: TextStyle(
                      color: Color.fromARGB(255, 82, 82, 82),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 2),
                    Icon(Icons.local_fire_department, color: Colors.orange),
                    Text(
                      "1.5x",
                      style: TextStyle(
                        color: Color.fromARGB(255, 223, 164, 76),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: 36 / 279,
                              backgroundColor:
                                  Color.fromARGB(255, 179, 199, 222),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.orange),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text("5/279"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMedalGrid(String currentTier) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          final isTierVisible = isTierUnlocked(index, unlockedCount);
          final isUnlocked = index < unlockedCount;
          final tier = getCurrentTier(index);
          final medalColor = getMedalColor(tier, isUnlocked);

          //  히든 업적 처리
          final isHidden = achievement.isHidden;
          final displayTitle =
              (!isUnlocked && isHidden) ? "???" : achievement.title;
          final displayDescription = (!isUnlocked && isHidden)
              ? "해금되지 않은 히든 업적입니다."
              : achievement.description;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(displayTitle),
                    content: Text(displayDescription),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("확인"),
                      ),
                    ],
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : isTierVisible
                              ? const Color.fromARGB(255, 176, 176, 176)
                              : const Color.fromARGB(255, 176, 176, 176),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: medalColor,
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      displayTitle, //  변경
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isUnlocked ? Colors.black : Colors.grey[600],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 40,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.medal,
                        size: 24,
                        color: isUnlocked ? medalColor : Colors.grey[600],
                      ),
                    ),
                  ),
                  if (!isUnlocked)
                    const Positioned(
                      right: 30,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Icon(
                          FontAwesomeIcons.lock,
                          size: 25,
                          color: Color.fromARGB(255, 116, 116, 116),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
