import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/pages/login.dart';

void main() {
  runApp(const UnionApp());
}

class UnionApp extends StatelessWidget {
  const UnionApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'Union',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 255, 200, 45)),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const UnionMainPage(title: 'Union'),
        );
      },
    );
  }
}

class UnionMainPage extends StatefulWidget {
  const UnionMainPage({super.key, required this.title});

  final String title;

  @override
  State<UnionMainPage> createState() => _UnionMainPageState();
}

class _UnionMainPageState extends State<UnionMainPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginPage(),
    );
  }
}
