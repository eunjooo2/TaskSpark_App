import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // 아이템 리스트 정의
  final List<Map<String, dynamic>> items = [
    {
      "image": "assets/icons/a.png",
      "title": "방어권",
      "description": "천연 재료로 만든 유니비누, 향이 좋아요!",
      "price": 5000,
    },
    {
      "image": "assets/icons/a.png",
      "title": "보상 부스트",
      "description": "친환경 소재로 제작된 텀블러입니다.",
    },
    {
      "image": "assets/icons/a.png",
      "title": "라이벌 신청권",
      "description": "깔끔한 디자인의 노트로 공부에 딱!",
    },
    {
      "image": "assets/icons/a.png",
      "title": "닉네임 변경",
      "description": "깔끔한 디자인의 노트로 공부에 딱!",
    },
    {
      "image": "assets/icons/a.png",
      "title": "태그 변경",
      "description": "깔끔한 디자인의 노트로 공부에 딱!",
    },
    {
      "image": "assets/icons/a.png",
      "title": "포인트 칭호",
      "description": "깔끔한 디자인의 노트로 공부에 딱!",
    },
    // 필요한 만큼 추가 가능
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, toolbarHeight: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //_buildProfileSection(),
            _buildItemGrid(),
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
          CircleAvatar(
            radius: 30,
            backgroundImage: const AssetImage("assets/icons/a.png"),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "디스커버즈님, 환영합니다!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Color.fromARGB(255, 225, 152, 57),
                      size: 16,
                    ),
                    const Text(
                      " 1.5x",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
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
          const Text(
            "12,345,678 SP",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemGrid() {
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
        return Container(
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
                item["title"]!,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  item["description"]!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
