import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/widgets/friend.dart';
import 'package:task_spark/data/friend.dart';
import 'package:task_spark/data/user.dart';
import 'package:task_spark/util/secure_storage.dart';
import 'package:task_spark/utils/services/friend_service.dart';
import 'package:task_spark/utils/services/rival_service.dart';
import 'package:task_spark/utils/services/user_service.dart';

class FriendExpanision extends StatefulWidget {
  const FriendExpanision({
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

  List<User?> users = [];
  List<bool> rivalRequestExists = [];
  bool isLoading = false;
  bool isMatched = false;

  DateTime nowDate = DateTime.now().toUtc();

  @override
  void initState() {
    super.initState();
    if (widget.data.isNotEmpty) {
      users = List<User?>.filled(widget.data.length, null);
      rivalRequestExists = List<bool>.filled(widget.data.length, false);
      loadUsers();
    }
    _fetchMatch();
  }

  Future<void> _fetchMatch() async {
    bool isMatch = await RivalService().isMatchedRival();
    setState(() {
      isMatched = isMatch;
    });
  }

  @override
  void didUpdateWidget(covariant FriendExpanision oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data.length != users.length) {
      users = List<User?>.filled(widget.data.length, null);
      rivalRequestExists = List<bool>.filled(widget.data.length, false);
      loadUsers();
    }
  }

  Future<void> loadUsers() async {
    setState(() {
      isLoading = true;
    });

    List<User?> loadedUsers = List<User?>.filled(widget.data.length, null);
    List<bool> loadedRequests = List<bool>.filled(widget.data.length, false);
    for (int i = 0; i < widget.data.length; i++) {
      loadedUsers[i] = await _fetchUser(i);
      loadedRequests[i] = await RivalService().isSendRequest(widget.data[i]);
    }

    setState(() {
      users = loadedUsers;
      rivalRequestExists = loadedRequests;
      isLoading = false;
    });
  }

  Future<User> _fetchUser(int index) async {
    final data = widget.isReceived != null
        ? (widget.isReceived == true
            ? await UserService().getUserByID(widget.data[index].senderId)
            : await UserService().getUserByID(widget.data[index].receiverId))
        : await UserService().getUserByID(
            await UserService().getOtherUserID(widget.data[index]));
    return data;
  }

  Widget? _buildActionButtons(String recordID, String type) {
    switch (type) {
      case "received":
        return Row(
          children: [
            IconButton(
              onPressed: () async {
                await FriendService().acceptFriendRequest(recordID);
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
                await FriendService().rejectFriendRequest(recordID);
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
            await FriendService().rejectFriendRequest(recordID);
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
    DateTime startDate = DateTime(nowDate.year, nowDate.month, nowDate.day, 0);
    DateTime endDate = DateTime(nowDate.year, nowDate.month, nowDate.day, 4);
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
                  actionButtons: _buildActionButtons(
                      widget.data[index].id, widget.expanisionType),
                  onTap: () {
                    final image = user.avatar != null && user.avatar!.isNotEmpty
                        ? NetworkImage("https://pb.aroxu.me/${user.avatar!}")
                        : const AssetImage("assets/images/default_profile.png")
                            as ImageProvider;
                    if (widget.expanisionType == "normal") {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.scale,
                        dialogType: DialogType.noHeader,
                        body: Column(children: [
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
                          SizedBox(height: 2.h),
                        ]),
                        btnOk: isMatched
                            ? ElevatedButton(
                                onPressed: () {},
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.grey,
                                  ),
                                ),
                                child: const Text(
                                  "라이벌 진행중",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : (rivalRequestExists[index] == true
                                ? ElevatedButton(
                                    onPressed: () {},
                                    style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.grey,
                                      ),
                                    ),
                                    child: const Text(
                                      "이미 신청됨",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : null),
                        btnOkText: "라이벌 신청",
                        btnOkOnPress: rivalRequestExists[index] == true
                            ? null
                            : () async {
                                DateTime tempStartDate = startDate;
                                DateTime tempEndDate = endDate;
                                tempStartDate =
                                    tempStartDate.add(Duration(days: 1));
                                tempEndDate =
                                    tempEndDate.add(Duration(days: 15));
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.noHeader,
                                  animType: AnimType.scale,
                                  btnOk: AnimatedButton(
                                    isFixedHeight: false,
                                    pressEvent: () async {
                                      if (tempEndDate
                                              .difference(tempStartDate) <
                                          Duration(days: 14)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            content: Text(
                                                "종료일은 시작일로부터 최소 14일 이후입니다."),
                                          ),
                                        );
                                        return;
                                      }

                                      if (tempStartDate.compareTo(tempEndDate) >
                                          0) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            content:
                                                Text("시작일과 종료일을 다시 확인해주세요."),
                                          ),
                                        );
                                        return;
                                      }

                                      try {
                                        tempStartDate = tempStartDate
                                            .add(Duration(hours: 9));
                                        tempEndDate =
                                            tempEndDate.add(Duration(hours: 9));
                                        await RivalService().sendRivalRequest(
                                            tempStartDate,
                                            tempEndDate,
                                            widget.data[index]);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            content: Text("라이벌 신청을 보냈습니다!"),
                                          ),
                                        );

                                        loadUsers();
                                        Navigator.of(context).pop();
                                      } catch (e, s) {
                                        print(s);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            content:
                                                Text("라이벌 신청중 오류가 발생하였습니다."),
                                          ),
                                        );
                                      }
                                    },
                                    text: '라이벌 신청',
                                    color: const Color(0xFF00CA71),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(50)),
                                    buttonTextStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  btnCancelText: "취소",
                                  btnCancelOnPress: () {},
                                  reverseBtnOrder: true,
                                  body: StatefulBuilder(
                                    builder: (context, setInnerState) {
                                      return SizedBox(
                                        width: 80.w,
                                        height: 20.h,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Text(
                                                "라이벌 신청하기",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Row(
                                              children: [
                                                SizedBox(width: 5.w),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final picked =
                                                        (await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          tempStartDate,
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                    ))!
                                                            .toUtc();
                                                    if (picked != null) {
                                                      setInnerState(() {
                                                        tempStartDate =
                                                            DateTime(
                                                          picked.year,
                                                          picked.month,
                                                          picked.day,
                                                          0, // 시간을 4시로 설정
                                                        );
                                                      });
                                                    }
                                                  },
                                                  child: Text("시작 날짜 선택"),
                                                ),
                                                SizedBox(width: 2.w),
                                                Text(
                                                  DateFormat("yyyy년 MM월 dd일")
                                                      .format(tempStartDate),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2.h),
                                            Row(
                                              children: [
                                                SizedBox(width: 5.w),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final picked =
                                                        (await showDatePicker(
                                                      context: context,
                                                      initialDate: tempEndDate,
                                                      firstDate: DateTime(2000),
                                                      lastDate: DateTime(2100),
                                                    ))!
                                                            .toUtc();
                                                    if (picked != null) {
                                                      setInnerState(() {
                                                        tempEndDate = DateTime(
                                                          picked.year,
                                                          picked.month,
                                                          picked.day,
                                                          4, // 시간을 4시로 설정
                                                        );
                                                      });
                                                    }
                                                  },
                                                  child: Text("종료 날짜 선택"),
                                                ),
                                                SizedBox(width: 3.w),
                                                Text(
                                                  DateFormat("yyyy년 MM월 dd일")
                                                      .format(tempEndDate),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2.h),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ).show();
                              },
                        btnCancelText: "친구 삭제",
                        btnCancelOnPress: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.question,
                            animType: AnimType.scale,
                            title: "친구 삭제",
                            desc: "정말로 삭제하시겠습니까?",
                            btnOkText: "예",
                            btnOkOnPress: () async {
                              await FriendService()
                                  .rejectFriendRequest(widget.data[index].id);
                              widget.onDataChanged?.call();
                            },
                            btnCancelText: "아니요",
                            btnCancelOnPress: () {},
                            reverseBtnOrder: true,
                          ).show();
                        },
                        reverseBtnOrder: true,
                      ).show();
                    } else {
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
                    }
                  },
                );
              }
            },
          ),
      ],
    );
  }
}
