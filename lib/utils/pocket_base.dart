import 'package:pocketbase/pocketbase.dart';

class PocketB {
  static final PocketB _instance = PocketB._internal();
  late PocketBase pocketBase;
  final String host = "https://pb.aroxu.me";

  factory PocketB() {
    return _instance;
  }

  PocketB._internal() {
    pocketBase = PocketBase(host);
  }
}
