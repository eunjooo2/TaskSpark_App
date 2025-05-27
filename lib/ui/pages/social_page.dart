import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/data/friend_data.dart';
import 'package:task_spark/ui/widgets/friend_expanision.dart';
import 'package:task_spark/utils/models/friend.dart';
import 'package:task_spark/utils/pocket_base.dart';
import 'package:task_spark/utils/secure_storage.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late List<FriendRequest> receiveFriendRequest = [];
  late List<FriendRequest> sentFriendRequest = [];
  late List<FriendRequest> acceptedFriends = [];

  Future<void> getFriend() async {
    final friendRequests = await PocketB().getFriendList();

    final user = await SecureStorage().storage.read(key: "userID");

    setState(() {
      receiveFriendRequest = friendRequests
          .where((f) =>
              f.status == FriendRequestStatus.pending && f.receiverId == user)
          .toList();

      sentFriendRequest = friendRequests
          .where((f) =>
              f.status == FriendRequestStatus.pending && f.senderId == user)
          .toList();

      acceptedFriends = friendRequests
          .where((f) => f.status == FriendRequestStatus.accepted)
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getFriend();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
      animationDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = receiveFriendRequest.isEmpty &&
        sentFriendRequest.isEmpty &&
        acceptedFriends.isEmpty;

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
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      FriendExpanision(
                        title: "요청 받은 친구 목록",
                        expanisionType: "received",
                        data: receiveFriendRequest,
                        isReceived: true,
                      ),
                      FriendExpanision(
                        title: "전송한 친구 요청 목록",
                        expanisionType: "transmited",
                        data: sentFriendRequest,
                        isReceived: false,
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
