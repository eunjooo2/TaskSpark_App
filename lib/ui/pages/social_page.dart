import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
      animationDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.5),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: "친구 목록"),
          Tab(text: "라이벌 목록"),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ListView.builder(
            itemCount: 50,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: GestureDetector(
                  onTap: () {
                    // 원하는 동작 추가
                  },
                  child: Card(
                    child: SizedBox(
                      width: 80.w,
                      height: 8.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("친구 $index"),
                          SizedBox(width: 10),
                          Text("상태: 온라인"),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const Center(
            child: Text("라이벌 페이지입니다"),
          ),
        ],
      ),
    );
  }
}
