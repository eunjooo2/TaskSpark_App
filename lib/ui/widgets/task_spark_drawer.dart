import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/pages/achievement_page.dart';
import 'package:task_spark/utils/models/user.dart';
import 'package:task_spark/utils/pocket_base.dart';
import 'package:task_spark/utils/secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaskSparkDrawer extends StatefulWidget {
  const TaskSparkDrawer({super.key});

  @override
  State<TaskSparkDrawer> createState() => _TaskSparkDrawerState();
}

class _TaskSparkDrawerState extends State<TaskSparkDrawer> {
  User? user;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final id = await SecureStorage().storage.read(key: "userID") ?? "";
    final fetchedUser = await PocketB().getUserByID(id);
    setState(() {
      user = fetchedUser;
    });
  }

  Widget _getDrawerIconRow(
    IconData icon,
    String text,
    Function onPressed,
  ) {
    return SizedBox(
      height: 6.h,
      child: FilledButton(
        onPressed: () {
          onPressed();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 4.w,
              ),
              child: FaIcon(
                icon,
                color: Colors.white,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 0.5.cm,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDividerWithText(String text, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            height: 1.5.h,
            indent: 0.3.cm,
            endIndent: 0.3.cm,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 0.5.cm,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            height: 1.5.h,
            indent: 0.3.cm,
            endIndent: 0.3.cm,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: user != null
          ? ListView(
              padding: EdgeInsets.zero,
              children: [
                Theme(
                  data: ThemeData(
                    dividerColor: Colors.transparent,
                    dividerTheme: const DividerThemeData(
                      color: Colors.transparent,
                    ),
                  ),
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    accountName: Text(
                      user!.name ?? "",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    accountEmail: Text(
                      user!.email ?? "",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: user!.avatar != null &&
                              user!.avatar!.isNotEmpty
                          ? NetworkImage(
                              "https://pb.aroxu.me/api/files/${user!.collectionId}/${user!.id}/${user!.avatar}")
                          : const AssetImage(
                              "assets/images/default_profile.png"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 1.5.h,
                  ),
                  child: Column(
                    children: [
                      _buildDividerWithText("계정", context),
                      _getDrawerIconRow(
                        FontAwesomeIcons.pencil,
                        "프로필 편집",
                        () {},
                      ),
                      _getDrawerIconRow(
                        FontAwesomeIcons.gifts,
                        "인벤토리",
                        () {},
                      ),
                      _getDrawerIconRow(
                        FontAwesomeIcons.medal,
                        "업적",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const ArchievePage();
                              },
                            ),
                          );
                        },
                      ),
                      _getDrawerIconRow(
                        FontAwesomeIcons.rightFromBracket,
                        "로그아웃",
                        () {},
                      ),
                      _buildDividerWithText("설정", context),
                      _getDrawerIconRow(
                        FontAwesomeIcons.gear,
                        "앱 설정",
                        () {},
                      ),
                      _getDrawerIconRow(
                        FontAwesomeIcons.userLock,
                        "차단 친구 설정",
                        () {},
                      ),
                    ],
                  ),
                )
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
