import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, toolbarHeight: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            _buildItemGrid(),
          ],
        ),
      ),
    );
  }

  // ProfileSection 수정 (a.png 이미지 추가)
  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.grey[200],
      child: Row(
        children: [
          // 여기에서 a.png 이미지 사용
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/icons/a.png"), // a.png 이미지 추가
            backgroundColor: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "디스커버즈님, 환영합니다!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: const Color.fromARGB(255, 225, 152, 57),
                      size: 16,
                    ),
                    Text(
                      " 1.5x",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 0.7, // 경험치 바
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

  // ItemGrid 수정 (a.png 이미지 추가)
  Widget _buildItemGrid() {
    return GridView.builder(
      shrinkWrap: true, // GridView가 필요한 만큼만 크기를 차지하도록 설정
      physics: NeverScrollableScrollPhysics(), // GridView 내부 스크롤 비활성화
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: 15,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 여기에서 a.png 이미지 사용
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage:
                    AssetImage('assets/icons/a.png'), // a.png 이미지 사용
              ),
              SizedBox(height: 5),
              Text(
                "이름",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "뭐 이 시발",
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
        );
      },
    );
  }
}
