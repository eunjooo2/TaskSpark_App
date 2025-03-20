import 'package:flutter/material.dart';
import 'package:task_spark/ui/pages/splash.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
<<<<<<< HEAD

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

=======
import 'package:task_spark/ui/pages/login.dart';
import 'package:task_spark/ui/pages/main_page.dart';

void main() {
  runApp(const TaskSparkApp());
}

class TaskSparkApp extends StatelessWidget {
  const TaskSparkApp({super.key});
>>>>>>> 5568a92f502fe933da5328bdc1bc6fa5b9514ef0
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
       builder: (context, orientation, screenType) { 
        return MaterialApp(
<<<<<<< HEAD
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'tlqkf',
          ),
        ),
        body: SplashPage(),
      ),
       
      );
       }
    );
  }
}
=======
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
    return MainPage();
  }
}
>>>>>>> 5568a92f502fe933da5328bdc1bc6fa5b9514ef0
