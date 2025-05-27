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

  Future<bool> sendFriendRequest(String nickname, num tag) async {
    final userID = await SecureStorage().storage.read(key: "userID");
    final body = <String, dynamic>{
      "sender": userID,
      "receiver": "test",
      "isAccepted": false,
      "isBlocked": false,
    };
    print(body);
    return true;
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
}
