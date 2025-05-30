import '../models/friend.dart';
import '../pocket_base.dart';
import 'package:pocketbase/pocketbase.dart';
import '../secure_storage.dart';

class FriendService {
  Future<List<RecordModel>> _getFriendRecordList() async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";
    return await PocketB()
        .pocketBase
        .collection("friends")
        .getFullList(filter: "sender.id='$userID'||receiver.id='$userID'");
  }

  Future<List<FriendRequest>> getFriendList() async {
    final friendRecordList = await _getFriendRecordList();
    final friendRequests = friendRecordList
        .map((json) => FriendRequest.fromRecordModel(json))
        .toList();

    return friendRequests;
  }

  Future<FriendRequest> getFriendByRecordID(String recordID) async {
    return FriendRequest.fromRecordModel(
        await PocketB().pocketBase.collection('friends').getOne(recordID));
  }

  Future<void> sendFriendRequest(String targetUserId) async {
    final userID = await SecureStorage().storage.read(key: "userID");
    final body = <String, dynamic>{
      "sender": userID,
      "receiver": targetUserId,
      "isAccepted": false,
      "isBlocked": false,
    };

    await PocketB().pocketBase.collection('friends').create(body: body);
  }

  Future<void> rejectFriendRequest(String recordID) async {
    await PocketB().pocketBase.collection('friends').delete(recordID);
  }

  Future<void> acceptFriendRequest(String recordID) async {
    FriendRequest originFriendRequest = FriendRequest.fromRecordModel(
        await PocketB().pocketBase.collection('friends').getOne(recordID));

    await PocketB().pocketBase.collection('friends').update(recordID, body: {
      "sender": originFriendRequest.senderId,
      "receiver": originFriendRequest.receiverId,
      "isAccepted": true,
    });
  }

  Future<bool> checkIsFriend(String targetUserId) async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";
    final friends = await PocketB().pocketBase.collection('friends').getFullList(
        filter:
            "((sender.id='$userID'&&receiver.id='$targetUserId')||(sender.id='$targetUserId'&&receiver.id='$userID'))&&isAccepted=true");

    return friends.length == 1;
  }

  Future<bool> alreadyRequestFriend(String targetUserId) async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";
    final friends = await PocketB().pocketBase.collection('friends').getFullList(
        filter:
            "sender.id='$userID'&&receiver.id='$targetUserId'&&isAccepted=false");

    return friends.length == 1;
  }

  Future<bool> isRequestFromTargetToMe(String targetUserId) async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";
    final friends = await PocketB().pocketBase.collection("friends").getFullList(
        filter:
            "sender.id='$targetUserId'&&receiver.id='$userID'&&isAccepted=false");

    return friends.length == 1;
  }

  Future<String> getRequestIDByTargetID(String targetUserId) async {
    String userID = await SecureStorage().storage.read(key: "userID") ?? "";

    final friends = await PocketB().pocketBase.collection('friends').getFullList(
        filter:
            "((sender.id='$userID'&&receiver.id='$targetUserId')||sender.id='$targetUserId'&&receiver.id='$userID')&&isAccepted=false");

    return friends[0].id;
  }
}
