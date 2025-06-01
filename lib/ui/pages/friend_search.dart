import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/widgets/friend.dart';
import 'package:task_spark/utils/models/user.dart';
import 'package:task_spark/utils/secure_storage.dart';
import 'package:task_spark/utils/services/user_service.dart';
import 'package:task_spark/utils/services/friend_service.dart';

class FriendSearchPage extends StatefulWidget {
  @override
  State<FriendSearchPage> createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends State<FriendSearchPage> with RouteAware {
  late final _searchController = TextEditingController();
  List<SearchUser> users = [];
  Map<String, bool> friendStatus = {};
  Map<String, bool> requestStatus = {};

  @override
  void initState() {
    super.initState();
  }

  Future<void> searchUser(String e) async {
    List<String> searchData = e.split("#");
    String nickname = searchData[0];
    int? tag;

    if (searchData.length != 1 &&
        searchData[1] != '' &&
        int.tryParse(searchData[1]) != null) {
      tag = int.parse(searchData[1]);
    }

    SearchData result =
        await UserService().getUserByNickanemAndTag(nickname, tag);

    final userID = await SecureStorage().storage.read(key: "userID");

    // 나 자신 제외
    final List<SearchUser> foundUsers =
        (result.data ?? []).where((user) => user.id != userID).toList();

    // 병렬 요청 처리
    final friendStatusResults = await Future.wait(
      foundUsers.map((user) async {
        final id = user.id ?? "";
        final isFriend = await FriendService().checkIsFriend(id);
        return MapEntry(id, isFriend);
      }),
    );

    final requestStatusResults = await Future.wait(
      foundUsers.map((user) async {
        final id = user.id ?? "";
        final isRequested = await FriendService().alreadyRequestFriend(id);
        return MapEntry(id, isRequested);
      }),
    );

    // Map 형태로 변환
    final Map<String, bool> friendMap = Map.fromEntries(friendStatusResults);
    final Map<String, bool> requestMap = Map.fromEntries(requestStatusResults);

    setState(() {
      users = foundUsers;
      friendStatus = friendMap;
      requestStatus = requestMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search",
          style: TextStyle(
            fontSize: 18.sp,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 3.h),
          SearchBar(
            hintText: "닉네임#태그 입력",
            onChanged: (String e) async {
              if (e != '') {
                await searchUser(e);
              }
              setState(() {});
            },
            controller: _searchController,
            leading: Padding(
              padding: EdgeInsets.only(left: 5.w, right: 2.w),
              child: const Icon(
                FontAwesomeIcons.search,
              ),
            ),
          ),
          Expanded(
            child: _searchController.text == ""
                ? Center(child: Text("검색어를 입력해주세요!"))
                : users.isEmpty
                    ? Center(child: Text("검색된 유저가 없습니다."))
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final id = user.id ?? "";
                          final isFriend = friendStatus[id] ?? false;
                          final isAlreadyRequested = requestStatus[id] ?? false;

                          return FriendCard(
                            searchUser: user,
                            isSearch: true,
                            actionButtons: isFriend
                                ? Text(
                                    "이미 친구입니다",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  )
                                : isAlreadyRequested
                                    ? TextButton(
                                        onPressed: () async {
                                          final recordID = await FriendService()
                                              .getRequestIDByTargetID(id);
                                          await FriendService()
                                              .rejectFriendRequest(recordID);
                                          setState(() {
                                            requestStatus[id] = false;
                                          });
                                        },
                                        child: Text(
                                          "요청 취소",
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: () async {
                                          final alreadyReceived =
                                              await FriendService()
                                                  .isRequestFromTargetToMe(
                                                      user.id ?? "");
                                          if (alreadyReceived) {
                                            final recordId =
                                                await FriendService()
                                                    .getRequestIDByTargetID(
                                                        user.id ?? "");
                                            await FriendService()
                                                .acceptFriendRequest(recordId);
                                            setState(() {
                                              friendStatus[id] = true;
                                            });
                                          } else {
                                            await FriendService()
                                                .sendFriendRequest(
                                                    user.id ?? "");
                                            setState(() {
                                              requestStatus[id] = true;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                content: Text("친구 요청을 보냈습니다!"),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text(
                                          "친구 요청",
                                          style: TextStyle(fontSize: 14.sp),
                                        ),
                                      ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
