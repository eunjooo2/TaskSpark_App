import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/data/friend_data.dart';
import 'package:task_spark/ui/widgets/friend_expanision.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  List<Map<String, dynamic>> receivedFriendRequest =
      friendDummyData.where((friend) {
    return friend["isReceived"] == true && friend["status"] == "pending";
  }).toList();

  List<Map<String, dynamic>> friendList = friendDummyData.where((friend) {
    return friend["status"] == "accepted";
  }).toList();

  List<Map<String, dynamic>> transmitedFriendRequest =
      friendDummyData.where((friend) {
    return friend["isReceived"] == false && friend["status"] == "pending";
  }).toList();

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
        unselectedLabelColor: Colors.white.withOpacity(0.4),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: "친구 목록"),
          Tab(text: "라이벌 목록"),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 2.h),
                FriendExpanision(
                  title: "요청 받은 친구 목록",
                  expanisionType: "received",
                  data: receivedFriendRequest,
                ),
                FriendExpanision(
                  title: "전송한 친구 요청 목록",
                  expanisionType: "transmited",
                  data: transmitedFriendRequest,
                ),
                FriendExpanision(
                  title: "친구 목록",
                  expanisionType: "normal",
                  data: friendList,
                ),
              ],
            ),
          ),
          const Center(
            child: Text("라이벌 페이지입니다"),
          ),
        ],
      ),
    );
  }
}
