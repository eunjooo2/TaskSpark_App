import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/pages/social_page.dart';
import 'package:task_spark/ui/pages/store_page.dart';
import 'package:task_spark/ui/pages/task_page.dart';
import 'package:task_spark/ui/widgets/task_spark_drawer.dart';
import 'package:task_spark/ui/pages/splash_page.dart';
import 'package:task_spark/utils/pocket_base.dart';
import 'package:task_spark/utils/secure_storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:task_spark/utils/validator.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> navigationList = ["Tasks", "Social", "Shop"];
  late TextEditingController _nicknameController = TextEditingController();
  late TextEditingController _tagController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String appBarTitle = "";

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    printUserID();
  }

  Future<void> printUserID() async {
    print(await SecureStorage().storage.read(key: "userID"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(
            fontSize: 18.sp,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Container(
          padding: EdgeInsets.only(left: 3.w),
          child: Center(
            child: IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.bars,
                color: Color.fromARGB(255, 59, 59, 59),
              ),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
          ),
        ),
        actions: [
          _selectedIndex == 1
              ? Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.plus,
                      color: Color.fromARGB(255, 59, 59, 59),
                    ),
                    onPressed: () {
                      SmartDialog.show(builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          width: 70.w,
                          height: 30.h,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 5.w,
                                      ),
                                      Text(
                                        "친구 추가하기",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Form(
                                    key: _formKey,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Nickname TextField는 2의 비율
                                        Flexible(
                                          flex: 2, // 2의 비율
                                          child: TextFormField(
                                              controller: _nicknameController,
                                              decoration: InputDecoration(
                                                labelText: "닉네임 입력",
                                              ),
                                              onChanged: (value) {
                                                String? result =
                                                    validateNickname(value);
                                                if (result != "") {
                                                  SmartDialog.showNotify(
                                                    msg: result ?? "",
                                                    notifyType:
                                                        NotifyType.warning,
                                                    alignment:
                                                        Alignment.topCenter,
                                                  );
                                                }
                                              }),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: TextFormField(
                                              controller: _tagController,
                                              decoration: InputDecoration(
                                                labelText: "태그 입력",
                                              ),
                                              onChanged: (value) {
                                                String? result =
                                                    validateTag(value);
                                                if (result != "") {
                                                  SmartDialog.showNotify(
                                                    msg: result ?? "",
                                                    notifyType:
                                                        NotifyType.warning,
                                                    alignment:
                                                        Alignment.topCenter,
                                                  );
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 1.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        child: Text(
                                          "닫기",
                                          style: TextStyle(
                                            color: Colors.white
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                        onPressed: () {
                                          SmartDialog.dismiss();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("친구 요청"),
                                        onPressed: () {},
                                      ),
                                      Container(
                                        width: 5.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  ),
                )
              : Padding(
                  padding: EdgeInsets.zero,
                  child: Container(),
                ),
        ],
      ),
      drawer: TaskSparkDrawer(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            items: [
              BottomNavigationBarItem(
                icon: const FaIcon(FontAwesomeIcons.listCheck),
                label: navigationList[0],
              ),
              BottomNavigationBarItem(
                icon: const FaIcon(FontAwesomeIcons.userGroup),
                label: navigationList[1],
              ),
              BottomNavigationBarItem(
                icon: const FaIcon(FontAwesomeIcons.store),
                label: navigationList[2],
              ),
            ],
            onTap: (int value) {
              setState(() {
                _selectedIndex = value;
              });
              _pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
          ),
        ),
      ),
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        controller: _pageController,
        itemBuilder: (context, index) {
          if (index == 0) {
            return TaskPage();
          } else if (index == 1) {
            return SocialPage(); // 소셜 페이지
          } else if (index == 2) {
            return ShopPage();
          }
          return null;
        },
        onPageChanged: (int index) {
          setState(() {
            appBarTitle = navigationList[index];
          });
        },
      ),
    );
  }
}
