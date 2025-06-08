import 'package:task_spark/data/friend.dart';
import 'package:task_spark/data/user.dart';
import 'package:task_spark/service/task_service.dart';
import 'package:task_spark/service/user_service.dart';
import 'package:task_spark/util/pocket_base.dart';
import 'package:task_spark/util/secure_storage.dart';
import 'package:task_spark/service/friend_service.dart';
import 'package:task_spark/data/rival.dart';
import 'package:task_spark/service/achievement_service.dart';

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
      "metadata": {"status": "pending"},
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

  Future<User> loadEnemyUser() async {
    final rival = await RivalService().loadMatchedRivalInfo();
    final friendRequestInfo =
        await FriendService().getFriendByRecordID(rival.friendID);
    final enemyUserID = await UserService().getOtherUserID(friendRequestInfo);
    final userInfo = await UserService().getUserByID(enemyUserID);

    return userInfo;
  }

  Future<void> acceptRivalRequest(String recordID) async {
    // 라이벌 요청 수락 처리
    final record = await PocketB()
        .pocketBase
        .collection("rivals")
        .update(recordID, body: {"isAccepted": true});

    // 현재 로그인한 사용자 ID 가져오기
    final String userID = (await SecureStorage().storage.read(key: "userID"))!;

    // 요청 보낸 사람 ID
    final String? senderID = record.get("sender")?["id"];
    // 요청 받은 친구 ID
    final String? friendID = record.get("friend")?["id"];
    // # 조건 1: 내가 라이벌 요청을 보냈고, 상대가 수락한 경우
    // # 조건 2: 상대가 나에게 보냈고, 내가 수락한 경우
    if (userID == senderID || userID == friendID) {
      await AchievementService().updateMetaDataWithKey("rival_challenge", 1);
      print("[업적] rival_challenge +1");
    }

    await _deleteRivalRequest();
  }

  Future<void> checkRivalVictory(RivalRequest request) async {
    final userID = await SecureStorage().storage.read(key: "userID") ?? "";

    // 승자인 경우에만 업적 증가
    if ((request.result == RivalRequestStatus.sender_win &&
            request.senderID == userID) ||
        (request.result == RivalRequestStatus.receiver_win &&
            request.friendID == userID)) {
      await AchievementService().updateMetaDataWithKey("rival_win", 1);
      print("[업적] rival_win +1");
    }
  }

// 라이벌 도전 수락 후, 기존에 보냈던 도전 요청들을 삭제
  Future<void> _deleteRivalRequest() async {
    final records = await loadSendRivalRequest();
    for (int i = 0; i < records.length; i++) {
      await PocketB().pocketBase.collection("rivals").delete(records[i].id);
    }
  }

  Future<void> deleteRivalRequest(String recordID) async {
    await PocketB().pocketBase.collection("rivals").delete(recordID);
  }

  Future<List<Map<String, dynamic>>> getMetaData() async {
    final response = await loadMatchedRivalInfo();
    final process = response.metadata["process"];

    if (process is List) {
      return process.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      return [];
    }
  }

  // metadata에서 nDay의 idnex에 해당하는 value를 return ({"user1": {"goal": 13, "done": 11}, "user2": {"goal": 14, "done": 11}})
  Future<Map<String, dynamic>> getMetaDataWithNDays(int nDay) async {
    final metadata = await getMetaData();

    return metadata[nDay - 1];
  }

  Future<void> insertNDayMetaData() async {
    final userID = await SecureStorage().storage.read(key: "userID");
    final rivalInfo = await loadMatchedRivalInfo();
    final metadata = await getMetaData();
    final enemy = await loadEnemyUser();
    final _taskService = TaskService(PocketB().pocketBase, UserService());

    final enemyGoal = await _taskService.getTaskGoalCount(enemy.id ?? "");
    final enemyDone = await _taskService.getTaskDoneCount(enemy.id ?? "");
    final myGoal = await _taskService.getTaskGoalCount(userID ?? "");
    final myDone = await _taskService.getTaskDoneCount(userID ?? "");
    metadata.add({
      "${enemy.id}": {"goal": enemyGoal, "done": enemyDone},
      "$userID": {"goal": myGoal, "done": myDone}
    });

    await PocketB().pocketBase.collection("rivals").update(rivalInfo.id, body: {
      "metadata": {"process": metadata}
    });
  }

  Future<RivalResult> getNDaysResult(int nDay) async {
    final response = await getMetaDataWithNDays(nDay);
    final myInfo = await UserService().getProfile();
    final enemyInfo = await loadEnemyUser();

    final myGoal = (response[myInfo.id]["goal"] ?? 0);
    final myDone = (response[myInfo.id]["done"] ?? 0);
    final enemyGoal = (response[enemyInfo.id]["goal"] ?? 0);
    final enemyDone = (response[enemyInfo.id]["done"] ?? 0);

    final myRatio = myGoal == 0 ? 0 : myDone / myGoal;
    final enemyRatio = enemyGoal == 0 ? 0 : enemyDone / enemyGoal;

    if (myRatio > enemyRatio) return RivalResult.win;
    if (myRatio == enemyRatio) return RivalResult.draw;
    return RivalResult.lose;
  }
}
