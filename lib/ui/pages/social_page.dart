import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/widgets/friend_expanision.dart';
import 'package:task_spark/ui/widgets/rival_expanision.dart';
import 'package:task_spark/data/friend.dart';
import 'package:task_spark/data/rival.dart';
import 'package:task_spark/data/user.dart';
import 'package:task_spark/util/secure_storage.dart';
import 'package:task_spark/service/friend_service.dart';
import 'package:task_spark/main.dart';
import 'package:task_spark/service/rival_service.dart';
import 'package:task_spark/service/user_service.dart';

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
  bool isUserLoading = true;
  bool isMatched = false;
  RivalRequest? rivalInfo;
  User? enemy;
  int dayDiff = 0;

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

    if (!mounted) return;

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

    if (!mounted) return;

    setState(() {
      sentRivalRequest = sentRivalRequests;
      receiveRivalRequest = receiveRivalRequests;
      isRivalLoading = false;
    });
  }

  Future<void> _fetchMatch() async {
    final matchResult = await RivalService().isMatchedRival();
    if (!mounted) return;
    setState(() {
      isMatched = matchResult;
    });
    if (isMatched == true) {
      final rival = await RivalService().loadMatchedRivalInfo();
      final friendRequestInfo =
          await FriendService().getFriendByRecordID(rival.friendID);
      final enemyUserID = await UserService().getOtherUserID(friendRequestInfo);
      final userInfo = await UserService().getUserByID(enemyUserID);
      setState(() {
        rivalInfo = rival;
        enemy = userInfo;
        isUserLoading = false;
        dayDiff = rival.end.difference(rival.start).inDays;
      });
    }
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
                  ? (isUserLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox.expand(
                          child: Column(
                            children: [
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        backgroundImage: enemy!.avatar !=
                                                    null &&
                                                enemy!.avatar!.isNotEmpty
                                            ? NetworkImage(
                                                    "https://pb.aroxu.me/${enemy!.avatar}")
                                                as ImageProvider
                                            : const AssetImage(
                                                "assets/images/default_profile.png"),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${enemy!.nickname}#${enemy!.tag.toString().padRight(4, '0')}",
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "경쟁 기간: ${DateFormat('MM월 dd일').format(rivalInfo!.start)} ~ ${DateFormat('MM월 dd일').format(rivalInfo!.end)} (${dayDiff}일)",
                                              style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: Colors.white60),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "레벨: ${UserService().convertExpToLevel(enemy!.exp ?? 0)}",
                                              style: TextStyle(fontSize: 15.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: Theme.of(context).colorScheme.secondary,
                                height: 4.h,
                                thickness: 1.5,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: dayDiff,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1.h,
                                        horizontal: 3.w,
                                      ),
                                      child: Card(
                                        color: index < 5
                                            ? (index < 2
                                                ? Colors.red[700]
                                                : Colors.indigoAccent[700])
                                            : null,
                                        child: SizedBox(
                                          width: 100.w,
                                          height: 10.h,
                                          child: Center(
                                            child: Text(
                                              "${index + 1}일차 할 일 목록 및 결과",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ))
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
