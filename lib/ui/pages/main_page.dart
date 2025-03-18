import 'package:flutter/material.dart';
import 'package:task_spark/ui/pages/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/widgets/task_spark_drawer.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
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
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.listCheck),
                label: "Tasks",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.userGroup),
                label: "Friends",
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.store),
                label: "Shop",
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
            return Center(
              child: Text("Hello World1"), // 할 일 리스트 페이지
            );
          } else if (index == 1) {
            return Center(
              child: Text("Hello World2"), // 소셜 페이지
            );
          } else if (index == 2) {
            return Center(
              child: Text("Hello World3"), // 상점 페이지
            );
          }
        },
      ),
    );
  }
}
