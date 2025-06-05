import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/widgets/friend.dart';
import 'package:task_spark/data/rival.dart';
import 'package:task_spark/data/user.dart';
import 'package:task_spark/utils/services/friend_service.dart';
import 'package:task_spark/utils/services/rival_service.dart';
import 'package:task_spark/utils/services/user_service.dart';

class RivalExpanision extends StatefulWidget {
  const RivalExpanision({
    super.key,
    required this.title,
    required this.expanisionType,
    required this.data,
    required this.isReceived,
    this.onDataChanged,
    this.onTap,
  });

  final String title;
  final String expanisionType;
  final List<RivalRequest> data;
  final bool? isReceived;
  final void Function()? onDataChanged;
  final VoidCallback? onTap;

  @override
  State<RivalExpanision> createState() => _RivalExpanisionState();
}

class _RivalExpanisionState extends State<RivalExpanision> {
  final List<String> supportedExpanisionType = [
    "received",
    "transmited",
  ];

  List<User?> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.data.isNotEmpty) {
      users = List<User?>.filled(widget.data.length, null);
      loadUsers();
    }
  }

  @override
  void didUpdateWidget(covariant RivalExpanision oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.length != users.length) {
      users = List<User?>.filled(widget.data.length, null);
      loadUsers();
    }
  }

  Future<void> loadUsers() async {
    setState(() {
      isLoading = true;
    });

    List<User?> loadedUsers = List<User?>.filled(widget.data.length, null);
    for (int i = 0; i < widget.data.length; i++) {
      loadedUsers[i] = await _fetchUser(i);
    }

    setState(() {
      users = loadedUsers;
      isLoading = false;
    });
  }

  Future<User> _fetchUser(int index) async {
    if (widget.isReceived == true) {
      return await UserService().getUserByID(widget.data[index].senderID);
    } else {
      final friend = await FriendService()
          .getFriendByRecordID(widget.data[index].friendID);
      String userID = await UserService().getOtherUserID(friend);

      return await UserService().getUserByID(userID);
    }
  }

  Widget? _buildActionButtons(String recordID, String type) {
    switch (type) {
      case "received":
        return Row(
          children: [
            IconButton(
              onPressed: () async {
                await RivalService().acceptRivalRequest(recordID);
                widget.onDataChanged?.call();
              },
              icon: FaIcon(
                FontAwesomeIcons.check,
                color: Colors.green,
                size: 18.sp,
              ),
            ),
            IconButton(
              onPressed: () async {
                await RivalService().deleteRivalRequest(recordID);
                widget.onDataChanged?.call();
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
            await RivalService().deleteRivalRequest(recordID);
            widget.onDataChanged?.call();
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

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const Border(),
      showTrailingIcon: false,
      initiallyExpanded: true,
      title: Row(
        children: [
          const Expanded(
            child: Divider(color: Colors.amber),
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
            child: Divider(color: Colors.amber),
          ),
        ],
      ),
      children: [
        if (isLoading)
          Padding(
            padding: EdgeInsets.all(2.h),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (widget.data.isEmpty)
          Padding(
            padding: EdgeInsets.all(2.h),
            child: Center(
              child: Text(
                "${widget.expanisionType == "received" ? "받은 요청이" : (widget.expanisionType == "transmited" ? "전송한 요청이" : "친구가")} 없습니다.${widget.expanisionType == "normal" ? "\n친구를 추가해 보세요!" : ""}",
                style: TextStyle(fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              final user = users[index];
              if (user == null) {
                return Padding(
                  padding: EdgeInsets.all(2.h),
                  child: Row(
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(width: 2.w),
                      const Text("유저 정보 로딩 중..."),
                    ],
                  ),
                );
              } else {
                return FriendCard(
                  generalUser: user,
                  isRival: true,
                  startDate: widget.data[index].start,
                  endDate: widget.data[index].end,
                  actionButtons: _buildActionButtons(
                      widget.data[index].id, widget.expanisionType),
                  onTap: () {
                    final image = user.avatar != null && user.avatar!.isNotEmpty
                        ? NetworkImage("https://pb.aroxu.me/${user.avatar!}")
                        : const AssetImage("assets/images/default_profile.png")
                            as ImageProvider;
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.noHeader,
                      body: Column(
                        children: [
                          Text(
                            "${user.nickname}#${user.tag.toString().padRight(4, '0')}님의 정보",
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
                                  Text(
                                      "레벨: ${UserService().convertExpToLevel(user.exp ?? 0)}"),
                                  Text(
                                      "생성일: ${DateFormat("yyyy년 MM월 dd일").format(user.created!)}"),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                        ],
                      ),
                    ).show();
                  },
                );
              }
            },
          ),
      ],
    );
  }
}
