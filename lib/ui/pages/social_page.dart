import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/data/friend_data.dart';

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
    return friend["isReceived"] == false && friend["status"] == "pending";
  }).toList();

  List<Map<String, dynamic>> friendList = friendDummyData.where((friend) {
    return friend["status"] == "accepted";
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
                ExpansionTile(
                  shape: const Border(),
                  showTrailingIcon: false,
                  initiallyExpanded: true,
                  title: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Colors.amber,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Text(
                          "요청 받은 친구 목록",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5.sp,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: receivedFriendRequest.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 1.h),
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              child: SizedBox(
                                width: 80.w,
                                height: 8.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(receivedFriendRequest[index]
                                        ["friendId"]),
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
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.amber,
                        indent: 0.5.cm,
                        endIndent: 0.25.cm,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.w),
                      child: Text(
                        "친구 목록",
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.amber,
                        indent: 0.25.cm,
                        endIndent: 0.5.cm,
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: friendList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: SizedBox(
                            width: 80.w,
                            height: 8.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(friendList[index]["friendId"]),
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
