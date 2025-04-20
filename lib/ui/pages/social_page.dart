import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SocialPage extends StatefulWidget {
  SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,
    animationDuration: const Duration(milliseconds: 400),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        labelColor: Colors.white,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        controller: tabController,
        tabs: [
          Tab(
            child: Text("친구 목록"),
          ),
          Tab(
            child: Text("라이벌 목록"),
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ListView.builder(
            itemCount: 50,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 1.h,
                ),
                child: Center(
                  child: Container(
                    height: 10.h,
                    width: 90.w,
                    child: ColoredBox(
                      color: Colors.red,
                      child: Text("index: $index"),
                    ),
                  ),
                ),
              );
            },
          ),
          Center(
            child: Text("Hello World This is Rival Page"),
          ),
        ],
      ),
    );
  }
}
