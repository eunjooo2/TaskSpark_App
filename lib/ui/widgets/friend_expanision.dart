import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/utils/models/friend.dart';
import 'package:task_spark/utils/models/user.dart';
import 'package:task_spark/utils/pocket_base.dart';

class FriendExpanision extends StatefulWidget {
  FriendExpanision({
    Key? key,
    required this.title,
    required this.expanisionType,
    required this.data,
    required this.isReceived,
  });

  final String title;
  final String expanisionType;
  final List<FriendRequest> data;
  final bool isReceived;

  @override
  State<FriendExpanision> createState() => _FriendExpanisionState();
}

class _FriendExpanisionState extends State<FriendExpanision> {
  final List<String> supportedExpanisionType = [
    "received",
    "transmited",
    "normal",
  ];

  Widget? _buildActionButtons(String type) {
    switch (type) {
      case "received":
        return Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: FaIcon(
                FontAwesomeIcons.check,
                color: Colors.green,
                size: 18.sp,
              ),
            ),
            IconButton(
              onPressed: () {},
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
          onPressed: () {},
          child: Text(
            "요청 취소",
            style: TextStyle(
              fontSize: 14.sp,
            ),
          ),
        );
      case "normal":
        return IconButton(
          onPressed: () {},
          icon: FaIcon(
            FontAwesomeIcons.info,
            color: Colors.grey,
            size: 18.sp,
          ),
        );
    }
    return null;
  }

  List<User?> users = [];

  void _fetchUser(int index) async {
    final data = widget.isReceived
        ? await PocketB().getUserByID(widget.data[index].senderId)
        : await PocketB().getUserByID(widget.data[index].receiverId);
    setState(() {
      users[index] = data;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.data.isNotEmpty) {
      users = List<User?>.filled(widget.data.length, null);

      for (int i = 0; i < widget.data.length; i++) {
        _fetchUser(i);
      }
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
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: GestureDetector(
                  onTap: () {},
                  child: Card(
                    child: SizedBox(
                      width: 80.w,
                      height: 8.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(user?.id ?? ""),
                          _buildActionButtons(widget.expanisionType) ??
                              SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
