import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/pages/friend_search.dart';
import 'package:task_spark/ui/pages/social_page.dart';
import 'package:task_spark/ui/pages/task_page.dart';
import 'package:task_spark/ui/widgets/task_spark_drawer.dart';
import 'package:task_spark/ui/pages/shop_page.dart';

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
            Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.search,
                  color: Color.fromARGB(255, 59, 59, 59),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FriendSearchPage(),
                    ),
                  );
                },
              ),
            )
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
