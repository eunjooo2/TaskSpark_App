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

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> navigationList = ["Tasks", "Social", "Shop"];
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
      ), // settings, achiev와 프로필 및 각종 설정이 Drawer 형태로 들어갈 것
      drawer: TaskSparkDrawer(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        child: Container(
          padding: const EdgeInsets.only(
            top: 5,
          ),
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
            return StorePage();
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
