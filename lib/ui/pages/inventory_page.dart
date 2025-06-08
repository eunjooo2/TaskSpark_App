import 'package:flutter/material.dart';
import 'package:task_spark/data/user.dart';
import 'package:task_spark/data/item.dart';
import 'package:task_spark/service/item_service.dart';
import 'package:task_spark/service/user_service.dart';
import 'package:task_spark/util/pocket_base.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final itemService = ItemService(PocketB().pocketBase);
  final userService = UserService();

  List<Item> items = [];
  User? user;
  List<Map<String, dynamic>> rawData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInventory();
  }

  Future<void> fetchUser() async {
    final loadUser = await userService.getProfile();
    setState(() {
      user = loadUser;
    });
  }

  Future<void> fetchInventory() async {
    await fetchUser();
    final rawItems = user?.inventory?["items"];
    if (rawItems is! List) {
      setState(() => isLoading = false);
      return;
    }

    rawData = rawItems.whereType<Map<String, dynamic>>().toList();
    rawData = rawData.where((e) => e["isUsed"] == false).toList();
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

  Future<void> handleUseItem(Item item) async {
    if (user == null) return;

    final raw = getRawById(item.id);
    int quantity = raw["quantity"] ?? 0;

    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: Text("아이템이 더 이상 없습니다.")),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("아이템 사용"),
        content: Text("${item.title} 아이템을 사용하시겠습니까?\n(남은 수량: $quantity개)"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("사용"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      quantity -= 1;
      raw["quantity"] = quantity;
      raw["isUsed"] = quantity == 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text("${item.title} 아이템을 1개 사용했습니다.")),
    );

    // ✅ PocketBase에 업데이트
    try {
      final updatedUser = await userService.updateInventory(user!.id!, rawData);
      debugPrint("인벤토리 업데이트 성공: ${updatedUser.id}");
    } catch (e) {
      debugPrint("인벤토리 업데이트 실패: $e");
    }
  }

  bool shouldShowUseButton(Item item, Map<String, dynamic> raw) {
    final quantity = raw["quantity"] ?? 0;
    final isUsed = raw["isUsed"] ?? false;
    return item.title != "x1.2경험치 부스트" &&
        item.title != "라이벌 신청권" &&
        !isUsed &&
        quantity > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('인벤토리',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: ClipOval(
                                child: item.image.isNotEmpty
                                    ? Container(
                                        width: 70,
                                        height: 70,
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Image.network(
                                          item.imageUrl,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.broken_image),
                                        ),
                                      )
                                    : const Icon(Icons.image),
                              ),
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
                                      style:
                                          TextStyle(color: Colors.grey[400])),
                                  Text(
                                    "사용 여부: ${isUsed ? "사용됨" : "미사용"}",
                                    style: TextStyle(
                                      color: isUsed
                                          ? Colors.red[200]
                                          : Colors.greenAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("구매일: $purchasedTime",
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  Text("만료일: $dueDate",
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  if (shouldShowUseButton(item, raw))
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: ElevatedButton(
                                          onPressed: () => handleUseItem(item),
                                          child: const Text("사용"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.greenAccent.shade700,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
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
    );
  }
}
