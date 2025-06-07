import 'package:flutter/material.dart';
import 'package:task_spark/service/user_service.dart';
import 'package:task_spark/data/user.dart';

class InventoryPage extends StatefulWidget {
  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Map<String, dynamic>? inventory;
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final userData = await UserService().getProfile();
    final inventoryData = await UserService().getUserInventory();

    setState(() {
      user = userData;
      inventory = inventoryData;
      isLoading = false;
    });
  }

  void _useItem(String itemName) async {
    if (user?.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 정보가 유효하지 않습니다.')),
      );
      return;
    }

    final success = await UserService().useItem(user!.id!, itemName);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$itemName 사용 완료!')),
      );
      _fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$itemName 사용 실패')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "인벤토리",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        leading: BackButton(color: Theme.of(context).colorScheme.secondary),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 프로필 섹션
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            user?.avatar != null && user!.avatar!.isNotEmpty
                                ? NetworkImage(user!.avatar!)
                                : null,
                        child: user?.avatar == null || user!.avatar!.isEmpty
                            ? Icon(Icons.person, size: 30)
                            : null,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.nickname ?? '닉네임 없음',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(
                              'Level ${UserService().convertExpToLevel(user?.exp ?? 0)}'),
                          Text('${user?.points ?? 0} SP'),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // 아이템 목록
                Expanded(
                  child: inventory == null || inventory!.isEmpty
                      ? Center(child: Text("보유한 아이템이 없습니다."))
                      : ListView.builder(
                          itemCount: inventory!.length,
                          itemBuilder: (context, index) {
                            final itemName = inventory!.keys.elementAt(index);
                            final quantity = inventory![itemName];

                            return ListTile(
                              title: Text(itemName),
                              subtitle: Text('수량: $quantity'),
                              trailing: ElevatedButton(
                                onPressed: () => _useItem(itemName),
                                child: Text('사용하기'),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
