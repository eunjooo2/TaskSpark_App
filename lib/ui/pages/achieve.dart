import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ArchievePage extends StatefulWidget {
  const ArchievePage({super.key});

  @override
  State<ArchievePage> createState() => _ArchievePageState();
}

class _ArchievePageState extends State<ArchievePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("업적"),
      ),
      body: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 10),
          _buildMedalGrid(),
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
            // 프로필 바
            alignment: Alignment.bottomRight,
            children: [
              const Icon(Icons.emoji_emotions, size: 60, color: Colors.orange),
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
                      const Text("37", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("디스커버즈님 환영합니다!"),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.orange),
                    Text("1.5x"),
                    SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 5 / 279,
                        backgroundColor: Color.fromARGB(255, 179, 199, 222),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text("5/279"),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ----------------
  Widget _buildMedalGrid() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 10,
        itemBuilder: (context, index) {
          bool isUnlocked = index < 2;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Container(
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 221, 227, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      FaIcon(
                        isUnlocked
                            ? FontAwesomeIcons.medal
                            : FontAwesomeIcons.lock, // 트로피 또는 잠금
                        size: 30,
                        color: isUnlocked ? Colors.grey : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
