import 'package:flutter/material.dart';
import 'package:task_spark/data/shop.dart';
import 'package:task_spark/data/user.dart';
import 'package:task_spark/service/shop_service.dart';
import 'package:task_spark/service/user_service.dart';
import 'package:task_spark/util/secure_storage.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int userPoints = 10000;
  String searchQuery = "";
  String _sortOption = "name"; // ✅ 정렬 기준 상태
  User? user;
  List<Shop> allItems = [];
  bool isLoading = true;
  bool isUserLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchUser();
  }

  void _fetchData() async {
    final response = await ShopService().getAllShopItems();
    setState(() {
      allItems = response;
      isLoading = false;
    });
  }

  void _fetchUser() async {
    final response = await UserService().getProfile();
    setState(() {
      user = response;
      isUserLoading = false;
      userPoints = response.points ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = allItems.where((item) {
      final name = item.title.toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    // ✅ 정렬 적용
    filteredItems.sort((a, b) {
      switch (_sortOption) {
        case 'price_asc':
          return a.price.compareTo(b.price);
        case 'price_desc':
          return b.price.compareTo(a.price);
        case 'name':
        default:
          return a.title.compareTo(b.title);
      }
    });

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, toolbarHeight: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildSearchBar(),
            // ✅ 드롭다운 추가
            _buildItemGrid(filteredItems),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    final image = user?.avatar != null && user!.avatar!.isNotEmpty
        ? NetworkImage(
            "https://pb.aroxu.me/api/files/_pb_users_auth_/${user!.id}/${user!.avatar}")
        : const AssetImage("assets/images/default_profile.png")
            as ImageProvider;
    return isUserLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[200],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: image,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${user!.nickname}님 환영합니다",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "레벨 ${UserService().convertExpToLevel(user!.exp ?? 0)}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: UserService()
                                .experienceToNextLevel(user!.exp as int) /
                            user!.exp!.toDouble(),
                        color: Colors.orange,
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "EXP: ${_formatPoints(user!.exp as int)} / ${_formatPoints(UserService().experienceToNextLevel(user!.exp as int) + user!.exp! as int)}",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.local_fire_department,
                              color: Color.fromARGB(255, 225, 152, 57),
                              size: 16),
                          SizedBox(width: 4),
                          Text("1.5x 부스터",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black54)),
                        ],
                      )
                    ],
                  ),
                ),
                Text(
                  "${_formatPoints(userPoints)} SP",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '아이템 검색...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          const Text("정렬: "),
          DropdownButton<String>(
            value: _sortOption,
            items: const [
              DropdownMenuItem(
                value: 'name',
                child: Text("이름순"),
              ),
              DropdownMenuItem(
                value: 'price_asc',
                child: Text("가격 낮은순"),
              ),
              DropdownMenuItem(
                value: 'price_desc',
                child: Text("가격 높은순"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _sortOption = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemGrid(List<Shop> items) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
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
                        width: 70,
                        height: 70,
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.network(
                            "https://pb.aroxu.me/api/files/pbc_940982958/${item.id}/${item.image}",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(item.title,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text(
                        "${_formatPoints(item.price)} SP",
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

  void _showPurchaseDialog(Shop item) {
    final itemPrice = item.price;
    final affordable = userPoints >= itemPrice;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${item.title} 구매"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 140,
                height: 140,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.network(
                    "https://pb.aroxu.me/api/files/pbc_940982958/${item.id}/${item.image}",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  item.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "가격: ${_formatPoints(item.price)} SP",
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
                  ? () async {
                      ShopService().buyItem(item.id);
                      setState(() {
                        userPoints = userPoints - itemPrice;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${item.title} 구매 완료!")),
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
