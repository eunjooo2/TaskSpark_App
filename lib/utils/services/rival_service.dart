import 'package:pocketbase/pocketbase.dart';
import 'package:task_spark/utils/models/friend.dart';
import 'package:task_spark/utils/pocket_base.dart';
import 'package:task_spark/utils/secure_storage.dart';

import '../models/rival.dart';

class RivalService {
  Future<RivalRequest> sendRivalRequest(
      DateTime start, DateTime end, FriendRequest friend) async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";
    final body = <String, dynamic>{
      "start": start.toIso8601String(),
      "end": end.toIso8601String(),
      "friend": friend.id,
      "sender": userID,
      "isAccepted": false,
      "result": RivalRequestStatus.pending.name,
    };
    return RivalRequest.fromRecord(
        await PocketB().pocketBase.collection("rivals").create(body: body));
  }

  Future<bool> isSendRequest(FriendRequest friend) async {
    final result = await PocketB()
        .pocketBase
        .collection("rivals")
        .getFullList(filter: "friend='${friend.id}'");

    return result.length == 1;
  }

  Future<List<RivalRequest>> loadSendRivalRequest() async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";
    final result = await PocketB()
        .pocketBase
        .collection("rivals")
        .getFullList(filter: "sender.id='$userID'");

    final rivalRequests =
        result.map((json) => RivalRequest.fromRecord(json)).toList();

    return rivalRequests;
  }

  Future<List<RivalRequest>> loadReceiveRivalRequest() async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";
    final result = await PocketB()
        .pocketBase
        .collection("rivals")
        .getFullList(filter: "friend.receiver.id='$userID'");

    final rivalRequests =
        result.map((json) => RivalRequest.fromRecord(json)).toList();

    return rivalRequests;
  }
}
