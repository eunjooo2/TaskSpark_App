import 'package:flutter/material.dart';
import 'package:task_spark/data/shop_item_data.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int userPoints = 50000;
  String searchQuery = "";
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
            backgroundImage: AssetImage(
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
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: Color.fromARGB(255, 225, 152, 57), size: 16),
                    const Text(" 1.5x",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 0.7,
                        color: const Color.fromARGB(255, 26, 17, 3),
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
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
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(item["image"]!),
                ),
                const SizedBox(height: 8),
                Text(
                  item["name"] ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 15, 15, 15),
                  ),
                ),
                const SizedBox(height: 4),
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
              Text(item["description"] ?? ""),
              const SizedBox(height: 10),
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
            TextButton(
              onPressed: affordable
                  ? () {
                      setState(() {
                        userPoints -= itemPrice;
                      });
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
