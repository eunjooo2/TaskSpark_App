import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/widgets/login_button.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 12.5.h),
                  Image.asset("assets/icons/icon.png"),
                  SizedBox(height: 12.5.h),
                  LoginButton(
                      backgroundColor: Colors.white,
                      buttonType: "google",
                      title: "Google 로그인",
                      onPressed: () async {
                        final pb = PocketBase("https://pb.aroxu.me");
                        final authData = await pb
                            .collection("users")
                            .authWithOAuth2("google", (url) async {
                          await launchUrl(url);
                        });

                        print(pb.authStore.isValid);
                        print(pb.authStore.token);
                      }),
                  LoginButton(
                    backgroundColor: Colors.yellow,
                    buttonType: "kakao",
                    title: "Kakao 로그인",
                    onPressed: () async {
                      final pb = PocketBase("https://pb.aroxu.me");
                      final authData = await pb
                          .collection("users")
                          .authWithOAuth2("kakao", (url) async {
                        await launchUrl(url);
                      });

                      print(pb.authStore.isValid);
                      print(pb.authStore.token);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
