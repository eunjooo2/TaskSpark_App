import 'package:pocketbase/pocketbase.dart';

class PocketB {
  static final PocketB _instance = PocketB._internal();
  late final PocketBase pocketBase;

  factory PocketB() => _instance;

  PocketB._internal() {
    pocketBase = PocketBase("https://pb.aroxu.me");
  }
}
