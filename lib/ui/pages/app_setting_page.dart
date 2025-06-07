import 'package:flutter/material.dart';

// 2025. 06. 07 : 앱 설정 화면 추가(다크 모드 토글 설정 구현 필요)
class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("앱 설정")),
      body: const Center(
        child: Text("앱 설정 기능은 준비 중입니다."),
      ),
    );
  }
}
