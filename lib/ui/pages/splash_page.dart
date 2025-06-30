import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/pages/main_page.dart';
import 'package:task_spark/util/secure_storage.dart';
import 'package:task_spark/ui/widgets/login_button.dart';
import 'package:task_spark/service/user_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _splashController;
  late final AnimationController _loginButtonsController;

  late final Animation<Offset> _loginButtonsAnimation;
  bool _showLoginButtons = false;

  @override
  void initState() {
    super.initState();

    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _loginButtonsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _loginButtonsAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _loginButtonsController,
      curve: Curves.easeOutCubic,
    ));

    _splashController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showLoginButtons = true;
        });
        _loginButtonsController.forward();
      }
    });
  }

  @override
  void dispose() {
    _splashController.dispose();
    _loginButtonsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _loginButtonsAnimation,
              child: Lottie.network(
                "https://lottie.host/9f2045f8-5f02-4ccb-8b83-2402fdb77c82/xs7v2QSoEl.json",
                controller: _splashController,
                onLoaded: (composition) {
                  _splashController
                    ..duration = composition.duration
                    ..forward();
                },
                width: 80.w,
              ),
            ),
            _showLoginButtons
                ? TickerMode(
                    enabled: _showLoginButtons,
                    child: SizedBox(
                      height: 20.h,
                      child: SlideTransition(
                        position: _loginButtonsAnimation,
                        child: FadeTransition(
                          opacity: _loginButtonsController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoginButton(
                                backgroundColor: Colors.white,
                                buttonType: "google",
                                title: "Google 로그인",
                                onPressed: () async {
                                  final userService = UserService();
                                  final authData = await userService
                                      .sendLoginRequest("google");

                                  if (authData.token != "") {
                                    await SecureStorage().storage.write(
                                          key: "userID",
                                          value: authData.record.id,
                                        );

                                    await SecureStorage().storage.write(
                                          key: "accessToken",
                                          value: authData.token,
                                        );

                                    final user = await userService.getProfile();
                                    await userService
                                        .updateLoginStreak(user); //  로그인 스트릭 반영

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const MainPage()),
                                    );
                                  } else {
                                    // 로그인 실패 처리
                                  }
                                },
                              ),
                              LoginButton(
                                backgroundColor: Colors.yellow,
                                buttonType: "kakao",
                                title: "Kakao 로그인",
                                onPressed: () async {
                                  final userService = UserService();
                                  final authData = await userService
                                      .sendLoginRequest("kakao");

                                  if (authData.token != "") {
                                    await SecureStorage().storage.write(
                                          key: "userID",
                                          value: authData.record.id,
                                        );

                                    await SecureStorage().storage.write(
                                          key: "accessToken",
                                          value: authData.token,
                                        );

                                    final user = await userService.getProfile();
                                    await userService
                                        .updateLoginStreak(user); // 로그인 스트릭 반영

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const MainPage()),
                                    );
                                  } else {
                                    // 로그인 실패 처리
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 20.h,
                  ),
          ],
        ),
      ),
    );
  }
}
