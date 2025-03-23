import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

class PocketB {
  static final PocketB _instance = PocketB._internal();
  late PocketBase pocketBase;

  factory PocketB() {
    return _instance;
  }

  PocketB._internal() {
    pocketBase = PocketBase("https://pb.aroxu.me");
  }

  Future<RecordAuth> sendLoginRequest(String provider) async {
    return await pocketBase.collection("users").authWithOAuth2(provider,
        (url) async {
      await launchUrl(url);
    });
  }
}
