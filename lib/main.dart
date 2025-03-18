import 'package:flutter/material.dart';
import 'package:task_spark/ui/pages/splash.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
       builder: (context, orientation, screenType) { 
        return MaterialApp(
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