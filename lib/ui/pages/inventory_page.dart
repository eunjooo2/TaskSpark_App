import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:task_spark/data/user.dart';
import 'package:task_spark/data/item.dart';
import 'package:task_spark/service/item_service.dart';

// 2025 .06 .07 : 아이템 페이지 추가
class InventoryPage extends StatefulWidget {
  final User user;

  const InventoryPage({super.key, required this.user});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final pb = PocketBase("https://pb.aroxu.me");
  late final ItemService itemService;

  List<Item> items = [];
  List<Map<String, dynamic>> rawData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    itemService = ItemService(pb);

    fetchInventory();
  }

  Future<void> fetchInventory() async {
    final rawItems = widget.user.inventory?["items"];
    if (rawItems is! List) {
      setState(() => isLoading = false);
      return;
    }

    rawData = rawItems.whereType<Map<String, dynamic>>().toList();
    final ids = rawData.map((e) => e["id"] as String).toList();

    try {
      final result = await itemService.getItemsByIds(ids);
      setState(() {
        items = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Map<String, dynamic> getRawById(String id) {
    return rawData.firstWhere((e) => e["id"] == id, orElse: () => {});
  }

  String getImageUrl(String recordId, String fileName) {
    return "https://pb.aroxu.me/api/files/item/$recordId/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('인벤토리', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(
          onPressed: () => Navigator.pop(context, true),
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? const Center(child: Text("보유 중인 아이템이 없습니다."))
          : ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final raw = getRawById(item.id);
          final quantity = raw["quantity"] ?? 0;
          final isUsed = raw["isUsed"] ?? false;
          final metadata = raw["metadata"] ?? {};
          final purchasedTime = metadata["purchasedTime"] ?? "알 수 없음";
          final dueDate = metadata["dueDate"] ?? "없음";

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            color: const Color(0xFF2A241F),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: item.image.isNotEmpty
                        ? NetworkImage(getImageUrl(item.id, item.image))
                        : null,
                    onBackgroundImageError: (_, __) => const Icon(Icons.image),
                    backgroundColor: Colors.black26,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("보유 수량: $quantity개",
                            style: TextStyle(color: Colors.grey[400])),
                        Text(
                          "사용 여부: ${isUsed ? "사용됨" : "미사용"}",
                          style: TextStyle(
                            color: isUsed ? Colors.red[200] : Colors.greenAccent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("구매일: $purchasedTime",
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("만료일: $dueDate",
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
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
