import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/data/user.dart';

class FriendCard extends StatefulWidget {
  final User? generalUser;
  final SearchUser? searchUser;
  final bool isSearch;
  final Widget? actionButtons;
  final VoidCallback? onTap;
  final bool isRival;
  final DateTime? startDate;
  final DateTime? endDate;

  const FriendCard({
    super.key,
    this.generalUser,
    this.searchUser,
    this.isSearch = false,
    this.actionButtons,
    this.onTap,
    this.isRival = false,
    this.startDate,
    this.endDate,
  });

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  dynamic get user => widget.isSearch ? widget.searchUser : widget.generalUser;

  @override
  Widget build(BuildContext context) {
    final image = user.avatar != null && user.avatar!.isNotEmpty
        ? NetworkImage("https://pb.aroxu.me/${user.avatar!}")
        : const AssetImage("assets/images/default_profile.png")
            as ImageProvider;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: SizedBox(
            width: double.infinity,
            height: 8.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: image,
                    backgroundColor: Colors.grey[200],
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${user.nickname}#${user.tag.toString().padRight(4, '0')}",
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.isRival)
                          Text(
                            "${DateFormat('yyyy년 MM월 dd일').format(widget.startDate!)} ~ ${DateFormat('yyyy년 MM월 dd일').format(widget.endDate!)}",
                            style: TextStyle(
                              fontSize: 13.sp,
                            ),
                          ),
                        if (widget.isRival) SizedBox(height: 1.h),
                      ],
                    ),
                  ),
                  if (widget.actionButtons != null) widget.actionButtons!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
