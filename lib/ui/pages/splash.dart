import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin{
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500),);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      child:Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Lottie.network(
        "https://lottie.host/40ac0f4e-76ed-43dc-8306-f4e3eeac34f1/b8xKHZtuqR.json",
        controller: _controller,
        onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward();
            },
        width: 80.w,
      ),
      ],
    )
    );
  }
}
