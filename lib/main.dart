import 'package:flutter/material.dart';
import 'package:task_spark/ui/pages/splash_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskSparkApp());
}

class TaskSparkApp extends StatefulWidget {
  const TaskSparkApp({super.key});

  @override
  State<TaskSparkApp> createState() => _TaskSparkAppState();
}

class _TaskSparkAppState extends State<TaskSparkApp> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final modalRoute = ModalRoute.of(context);
      if (modalRoute != null) {
        routeObserver.subscribe(this, modalRoute);
      }
    });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // 이 함수는 현재 페이지가 다시 보일 때 호출됨
  @override
  void didPopNext() {
    refreshDataIfNeeded();
  }

  void refreshDataIfNeeded() {
    print("뒤에서 돌아왔음! 상태 갱신할게요");
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'TaskSpark',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 200, 45),
              brightness: Brightness.dark,
            ).copyWith(
              primary: const Color.fromARGB(255, 255, 200, 45),
              secondary: const Color.fromARGB(255, 59, 59, 59),
            ),
            useMaterial3: true,
          ),
          navigatorObservers: [
            FlutterSmartDialog.observer,
            routeObserver,
          ],
          builder: FlutterSmartDialog.init(),
          debugShowCheckedModeBanner: false,
          home: const TaskSparkMainPage(title: 'TaskSpark'),
        );
      },
    );
  }
}

class TaskSparkMainPage extends StatefulWidget {
  const TaskSparkMainPage({super.key, required this.title});

  final String title;

  @override
  State<TaskSparkMainPage> createState() => _TaskSparkMainPageState();
}

class _TaskSparkMainPageState extends State<TaskSparkMainPage> {
  @override
  Widget build(BuildContext context) {
    return SplashPage();
  }
}
