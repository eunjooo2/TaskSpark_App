import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/pages/login.dart';

void main() {
  runApp(const TaskSparkApp());
}

class TaskSparkApp extends StatelessWidget {
  const TaskSparkApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'TaskSpark',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 255, 200, 45)),
            useMaterial3: true,
          ),
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
    return const Scaffold(
      body: LoginPage(),
    );
  }
}
