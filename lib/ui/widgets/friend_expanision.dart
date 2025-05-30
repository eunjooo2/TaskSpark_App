import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  });

  final String title;
  final String expanisionType;
  final List<FriendRequest> data;
  final bool? isReceived;
  final void Function()? onDataChanged;

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
      case "accepted":
        return TextButton(
          onPressed: () async {
            await FriendService().rejectFriendRequest(recordID);
            if (widget.onDataChanged != null) {
              widget.onDataChanged!(); // 상위에서 전체 데이터 새로고침
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("친구를 삭제하였습니다!"),
                backgroundColor: Theme.of(context).colorScheme.primary));
          },
          child: Text(
            "친구 삭제",
            style: TextStyle(
              color: Color(0xFFFF8888),
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
                );
              }
            }
          },
        ),
      ],
    );
  }
}
