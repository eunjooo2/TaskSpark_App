import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FriendExpanision extends StatelessWidget {
  FriendExpanision({
    Key? key,
    required this.title,
    required this.expanisionType,
    required this.data,
  });

  final String title;
  final String expanisionType;
  final List<Map<String, dynamic>> data;
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
              title,
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
          itemCount: data.length,
          itemBuilder: (context, index) {
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
                        Text(data[index]["friendId"]),
                        _buildActionButtons(expanisionType) ?? SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
