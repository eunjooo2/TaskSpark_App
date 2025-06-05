import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/widgets/friend_expanision.dart';
import 'package:task_spark/ui/widgets/rival_expanision.dart';
import 'package:task_spark/utils/models/friend.dart';
import 'package:task_spark/utils/models/rival.dart';
import 'package:task_spark/utils/secure_storage.dart';
import 'package:task_spark/utils/services/friend_service.dart';
import 'package:task_spark/main.dart';
import 'package:task_spark/utils/services/rival_service.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with SingleTickerProviderStateMixin, RouteAware {
  late TabController tabController;
  late List<FriendRequest> receiveFriendRequest = [];
  late List<FriendRequest> sentFriendRequest = [];
  late List<FriendRequest> acceptedFriends = [];
  late List<RivalRequest> receiveRivalRequest = [];
  late List<RivalRequest> sentRivalRequest = [];
  bool isFriendLoading = true;
  bool isRivalLoading = true;
  bool isMatched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _fetchMatch();
    getFriend();
    getRival();
  }

  Future<void> getFriend() async {
    final friendRequests = await FriendService().getFriendList();

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

      isFriendLoading = false;
    });
  }

  Future<void> getRival() async {
    final sentRivalRequests = await RivalService().loadSendRivalRequest();
    final receiveRivalRequests = await RivalService().loadReceiveRivalRequest();
    setState(() {
      sentRivalRequest = sentRivalRequests;
      receiveRivalRequest = receiveRivalRequests;
      isRivalLoading = false;
    });
  }

  Future<void> _fetchMatch() async {
    final matchResult = await RivalService().isMatchedRival();
    setState(() {
      isMatched = matchResult;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMatch();
    getFriend();
    getRival();
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
          isFriendLoading
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
                        onDataChanged: getFriend,
                      ),
                      FriendExpanision(
                          title: "전송한 친구 요청 목록",
                          expanisionType: "transmited",
                          data: sentFriendRequest,
                          isReceived: false,
                          onDataChanged: getFriend),
                      FriendExpanision(
                        title: "친구 목록",
                        expanisionType: "normal",
                        data: acceptedFriends,
                        isReceived: null,
                        onDataChanged: getFriend,
                      ),
                    ],
                  ),
                ),
          isRivalLoading
              ? const Center(child: CircularProgressIndicator())
              : (isMatched
                  ? const Center(
                      child: Text(
                        "매칭 성공",
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 2.h),
                          RivalExpanision(
                            title: "요청 받은 라이벌 목록",
                            expanisionType: "received",
                            data: receiveRivalRequest,
                            isReceived: true,
                            onDataChanged: getRival,
                          ),
                          RivalExpanision(
                            title: "전송한 라이벌 요청 목록",
                            expanisionType: "transmited",
                            data: sentRivalRequest,
                            isReceived: false,
                            onDataChanged: getRival,
                          ),
                        ],
                      ),
                    )),
        ],
      ),
    );
  }
}
