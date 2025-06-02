import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widgets/task_spark_drawer.dart';
import '../pages/task_page.dart';
import '../pages/social_page.dart';
import '../pages/shop_page.dart';
import '../../util/secure_storage.dart';
import '../../util/validator.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nicknameController = TextEditingController();
  final _tagController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _navigationTitles = ["Tasks", "Social", "Shop"];
  int _selectedIndex = 0;
  String _appBarTitle = "Tasks";

  @override
  void dispose() {
    _pageController.dispose();
    _nicknameController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
      _appBarTitle = _navigationTitles[index];
    });
    _pageController.jumpToPage(index);
  }

  void _showAddFriendDialog() {
    SmartDialog.show(builder: (context) {
      return Container(
        width: 70.w,
        height: 30.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "친구 추가하기",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withAlpha(180),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _nicknameController,
                      decoration: const InputDecoration(labelText: "닉네임"),
                      onChanged: (value) {
                        final msg = validateNickname(value);
                        if (msg != null) {
                          SmartDialog.showNotify(
                            msg: msg,
                            notifyType: NotifyType.warning,
                            alignment: Alignment.topCenter,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _tagController,
                      decoration: const InputDecoration(labelText: "태그"),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final msg = validateTag(value);
                        if (msg != null) {
                          SmartDialog.showNotify(
                            msg: msg,
                            notifyType: NotifyType.warning,
                            alignment: Alignment.topCenter,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: SmartDialog.dismiss,
                  child: Text("닫기", style: TextStyle(color: Colors.white.withAlpha(130))),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: 친구 요청 API 호출 예정
                  },
                  child: const Text("친구 요청"),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const TaskSparkDrawer(),
      appBar: AppBar(
        title: Text(
          _appBarTitle,
          style: TextStyle(
            fontSize: 18.sp,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.bars, color: Color(0xFF3B3B3B)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          if (_selectedIndex == 1)
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.plus, color: Color(0xFF3B3B3B)),
              onPressed: _showAddFriendDialog,
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          TaskPage(),
          SocialPage(),
          ShopPage(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
              icon: const FaIcon(FontAwesomeIcons.listCheck),
              label: _navigationTitles[0],
            ),
            BottomNavigationBarItem(
              icon: const FaIcon(FontAwesomeIcons.userGroup),
              label: _navigationTitles[1],
            ),
            BottomNavigationBarItem(
              icon: const FaIcon(FontAwesomeIcons.store),
              label: _navigationTitles[2],
            ),
          ],
        ),
      ),
    );
  }
}
