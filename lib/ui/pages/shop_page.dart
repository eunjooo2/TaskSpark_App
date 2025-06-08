import 'package:flutter/material.dart';
import 'package:task_spark/service/achievement_service.dart';
import '../../data/static/shop_item_data.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int userPoints = 10000;
  int userExperience = 50000;
  int userLevel = 0;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _updateUserLevel();
  }

  int _expForLevel(int level) {
    if (level <= 0) return 0;
    return 50 * level * level + 100 * level;
  }

  void _updateUserLevel() {
    int calculatedLevel = 0;
    while (userExperience >= _expForLevel(calculatedLevel + 1)) {
      calculatedLevel++;
    }
    if (userLevel != calculatedLevel) {
      setState(() {
        userLevel = calculatedLevel;
      });
    }
  }

  int get maxExpForNextLevelUp => _expForLevel(userLevel + 1);
  int get minExpForCurrentLevel => _expForLevel(userLevel);

  double get progressFraction {
    final required = maxExpForNextLevelUp - minExpForCurrentLevel;
    final earned = userExperience - minExpForCurrentLevel;
    if (required <= 0) return 1.0;
    return earned / required;
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = allItems.where((item) {
      final name = item["name"]?.toLowerCase() ?? "";
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, toolbarHeight: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            _buildSearchBar(),
            _buildItemGrid(filteredItems),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey[200],
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: const AssetImage(
              "assets/images/default_profile.png",
            ),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "디스커버즈님!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "레벨 $userLevel",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progressFraction.clamp(0.0, 1.0),
                  color: Colors.orange,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 4),
                Text(
                  "EXP: ${_formatPoints(userExperience - minExpForCurrentLevel)} / ${_formatPoints(maxExpForNextLevelUp - minExpForCurrentLevel)}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.local_fire_department,
                        color: Color.fromARGB(255, 225, 152, 57), size: 16),
                    SizedBox(width: 4),
                    Text("1.5x 부스터",
                        style: TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                )
              ],
            ),
          ),
          Text(
            "${_formatPoints(userPoints)} SP",
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: '아이템 검색...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildItemGrid(List<Map<String, String>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => _showPurchaseDialog(item),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    item["image"]!,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(item["name"] ?? "",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
                const SizedBox(height: 4),
                Text(
                  "${_formatPoints(int.parse(item["price"]!))} SP",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPurchaseDialog(Map<String, String> item) {
    final itemPrice = int.parse(item["price"]!);
    final affordable = userPoints >= itemPrice;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${item["name"]} 구매"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(item["image"]!, width: 60, height: 60),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  item["description"] ?? "",
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "가격: ${_formatPoints(itemPrice)} SP",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (!affordable)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "보유 포인트가 부족합니다!",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소"),
            ),
            // 수정 전 >>>
            // TextButton(
            //   onPressed: affordable
            //       ? () {
            //           setState(() {
            //             userPoints -= itemPrice;
            //           });
            //           Navigator.pop(context);
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             SnackBar(content: Text("${item["name"]} 구매 완료!")),
            //           );
            //         }
            //       : null,
            //   child: const Text("구매하기"),
            // ),
            TextButton(
              onPressed: affordable
                  ? () async {
                      setState(() {
                        userPoints -= itemPrice;
                      });

                      // # [업적 연동] 아이템 구매 업적 증가
                      await AchievementService()
                          .updateMetaDataWithKey("buy_item", 1);

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${item["name"]} 구매 완료!")),
                      );
                    }
                  : null,
              child: const Text("구매하기"),
            ),
          ],
        );
      },
    );
  }

  String _formatPoints(int points) {
    return points.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
  }
}
