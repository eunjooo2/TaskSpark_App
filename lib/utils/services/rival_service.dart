import 'package:task_spark/utils/models/friend.dart';
import 'package:task_spark/utils/pocket_base.dart';
import 'package:task_spark/utils/secure_storage.dart';
import 'package:task_spark/utils/services/friend_service.dart';

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
    final userID = await SecureStorage().storage.read(key: "userID");
    final result = await PocketB().pocketBase.collection("rivals").getFullList(
        filter:
            'friend.id="${friend.id}"&&sender.id="$userID"&&isAccepted=false');

    return result.length == 1;
  }

  Future<bool> isReceiveRequest(FriendRequest friend) async {
    final userID = await SecureStorage().storage.read(key: "userID");
    final result = await PocketB().pocketBase.collection("rivals").getFullList(
        filter:
            'friend.id="${friend.id}"&&sender.id!="$userID"&&isAccepted=false');

    return result.length == 1;
  }

  Future<List<RivalRequest>> loadSendRivalRequest() async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";
    final result = await PocketB()
        .pocketBase
        .collection("rivals")
        .getFullList(filter: "sender.id='$userID'&&isAccepted=false");

    final rivalRequests =
        result.map((json) => RivalRequest.fromRecord(json)).toList();

    return rivalRequests;
  }

  Future<List<RivalRequest>> loadReceiveRivalRequest() async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";
    final result = await PocketB().pocketBase.collection("rivals").getFullList(
        filter:
            "(friend.receiver.id='$userID'||friend.sender.id='$userID')&&sender.id!='$userID'&&isAccepted=false");

    final rivalRequests =
        result.map((json) => RivalRequest.fromRecord(json)).toList();

    return rivalRequests;
  }

  Future<bool> isMatchedRival() async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";
    List<FriendRequest> friends = await FriendService().getFriendList();

    final friendIds = friends.map((f) => f.id).toList();

    final filter = friendIds.map((id) => 'friend.id="$id"').join('||');

    final result = await PocketB().pocketBase.collection('rivals').getFullList(
          filter: "($filter||sender.id='$userID')&&isAccepted=true",
        );

    return result.length == 1;
  }

  Future<RivalRequest> loadMatchedRivalInfo() async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";
    List<FriendRequest> friends = await FriendService().getFriendList();

    final friendIds = friends.map((f) => f.id).toList();

    final filter = friendIds.map((id) => 'friend.id="$id"').join('||');

    final result = await PocketB().pocketBase.collection('rivals').getFullList(
          filter: "($filter||sender.id='$userID')&&isAccepted=true",
        );

    return RivalRequest.fromRecord(result[0]);
  }

  Future<void> acceptRivalRequest(String recordID) async {
    await PocketB()
        .pocketBase
        .collection("rivals")
        .update(recordID, body: {"isAccepted": true});

    await _deleteRivalRequest();
  }

  Future<void> _deleteRivalRequest() async {
    final records = await loadSendRivalRequest();
    for (int i = 0; i < records.length; i++) {
      await PocketB().pocketBase.collection("rivals").delete(records[i].id);
    }
  }

  Future<void> deleteRivalRequest(String recordID) async {
    await PocketB().pocketBase.collection("rivals").delete(recordID);
  }
}
