import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/widgets/friend.dart';
import 'package:task_spark/utils/models/friend.dart';
import 'package:task_spark/utils/models/user.dart';
import 'package:task_spark/utils/secure_storage.dart';
import 'package:task_spark/utils/services/friend_service.dart';
import 'package:task_spark/utils/services/user_service.dart';

class FriendExpanision extends StatefulWidget {
  FriendExpanision({
    Key? key,
    required this.title,
    required this.expanisionType,
    required this.data,
    required this.isReceived,
    this.onDataChanged,
    this.onTap,
  });

  final String title;
  final String expanisionType;
  final List<FriendRequest> data;
  final bool? isReceived;
  final void Function()? onDataChanged;
  final VoidCallback? onTap;

  @override
  State<FriendExpanision> createState() => _FriendExpanisionState();
}

class _FriendExpanisionState extends State<FriendExpanision> {
  final List<String> supportedExpanisionType = [
    "received",
    "transmited",
    "normal",
  ];

  Widget? _buildActionButtons(String recordID, String type) {
    switch (type) {
      case "received":
        return Row(
          children: [
            IconButton(
              onPressed: () async {
                await FriendService().acceptFriendRequest(recordID);
                if (widget.onDataChanged != null) {
                  widget.onDataChanged!();
                }
              },
              icon: FaIcon(
                FontAwesomeIcons.check,
                color: Colors.green,
                size: 18.sp,
              ),
            ),
            IconButton(
              onPressed: () async {
                await FriendService().rejectFriendRequest(recordID);
                if (widget.onDataChanged != null) {
                  widget.onDataChanged!(); // 상위에서 전체 데이터 새로고침
                }
              },
              icon: FaIcon(
                FontAwesomeIcons.x,
                color: Colors.red,
                size: 18.sp,
              ),
            ),
          ],
        );
      case "transmited":
        return TextButton(
          onPressed: () async {
            await FriendService().rejectFriendRequest(recordID);
            if (widget.onDataChanged != null) {
              widget.onDataChanged!(); // 상위에서 전체 데이터 새로고침
            }
          },
          child: Text(
            "요청 취소",
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        );
    }
    return null;
  }

  List<User?> users = [];

  Future<String> getOtherUserID(FriendRequest request) async {
    String? myUserID = await SecureStorage().storage.read(key: "userID");
    if (request.senderId == myUserID) {
      return request.receiverId;
    } else {
      return request.senderId;
    }
  }

  Future<User> _fetchUser(int index) async {
    final data = widget.isReceived != null
        ? (widget.isReceived == true
            ? await UserService().getUserByID(widget.data[index].senderId)
            : await UserService().getUserByID(widget.data[index].receiverId))
        : await UserService()
            .getUserByID(await getOtherUserID(widget.data[index]));
    return data;
  }

  @override
  void initState() {
    super.initState();
    if (widget.data.isNotEmpty) {
      users = List<User?>.filled(widget.data.length, null);
      loadUsers(); // 비동기 로드 함수 분리
    }
  }

  Future<void> loadUsers() async {
    for (int i = 0; i < widget.data.length; i++) {
      User user = await _fetchUser(i);
      setState(() {
        users[i] = user;
      });
    }
  }

  @override
  void didUpdateWidget(covariant FriendExpanision oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.length != users.length) {
      users = List<User?>.filled(widget.data.length, null);
      loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
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
              widget.title,
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
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            if (widget.data.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(2.h),
                child: Center(
                  child: Text(
                    "데이터가 없습니다",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              );
            } else {
              final user = users[index];
              if (user == null) {
                return Padding(
                  padding: EdgeInsets.all(2.h),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 2.w),
                      Text("유저 정보 로딩 중..."),
                    ],
                  ),
                );
              } else {
                return FriendCard(
                    generalUser: user,
                    actionButtons: _buildActionButtons(
                        widget.data[index].id, widget.expanisionType),
                    onTap: () {
                      final image = user.avatar != null &&
                              user.avatar!.isNotEmpty
                          ? NetworkImage("https://pb.aroxu.me/${user.avatar!}")
                          : const AssetImage(
                                  "assets/images/default_profile.png")
                              as ImageProvider;
                      if (widget.expanisionType == "normal") {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.scale,
                          dialogType: DialogType.noHeader,
                          body: Column(children: [
                            Text(
                              "${user.nickname}#${user.tag}님의 정보",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: CircleAvatar(
                                    radius: 25.sp,
                                    backgroundImage: image,
                                    backgroundColor: Colors.grey[200],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("이름: ${user.name}"),
                                    Text("닉네임: ${user.nickname}"),
                                    Text("레벨: ${50}"),
                                    Text(
                                        "생성일: ${DateFormat("yyyy년 MM월 dd일").format(user.created!)}"),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                          ]),
                          btnOkText: "라이벌 신청",
                          btnOkOnPress: () {},
                          btnCancelText: "친구 삭제",
                          btnCancelOnPress: () {},
                        ).show();
                      }
                    });
              }
            }
          },
        ),
      ],
    );
  }
}
