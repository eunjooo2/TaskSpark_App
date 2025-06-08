import 'package:pocketbase/pocketbase.dart';
import '../data/task.dart';
import 'package:task_spark/service/achievement_service.dart';
import '../util/secure_storage.dart';
import 'user_service.dart';
import 'package:intl/intl.dart';

class TaskService {
  final PocketBase pb;
  final UserService userService;

  TaskService(this.pb, this.userService);

  /// 로그인한 사용자의 모든 할 일을 조회
  Future<List<Task>> getAllTasks() async {
    final userId = await SecureStorage().storage.read(key: "userID");

    final result = await pb.collection('tasks').getFullList(
          filter: "owner.id='$userId'",
          sort: "-created",
        );

    return result.map(Task.fromRecord).toList();
  }

  /// 할 일 ID로 단일 할 일을 조회
  Future<Task?> getTaskById(String id) async {
    try {
      final record = await pb.collection('tasks').getOne(id);
      return Task.fromRecord(record);
    } catch (_) {
      return null;
    }
  }

  /// 새 할 일 생성
  Future<Task> createTask(Task task) async {
    final userId = await SecureStorage().storage.read(key: "userID");

    final body = {
      ...task.toJson(),
      "owner": userId,
    };

    final record = await pb.collection('tasks').create(body: body);

    await AchievementService().increaseAchievement("add_task_total");

    final weekday = task.startDate?.weekday;
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      await AchievementService().updateMetaDataWithKey("weekend_task", 1);
    }

    // # 업적: 누구보다 빠르게 남들과는 다르게: 1시간 내에 10개
    // final isHighPriority = task.priority == "1";
    // if (isHighPriority) {
    //   await AchievementService()
    //       .updateMetaDataWithKey("fast_task_completion", 1);
    // }

    if (task.categoryId != null && task.categoryId!.isNotEmpty) {
      await AchievementService().updateMetaDataWithKey("category_sort_use", 1);
    }

    return Task.fromRecord(record);
  }

  /// 할 일을 수정
  Future<Task> updateTask(String id, Map<String, dynamic> data) async {
    final body = Map<String, dynamic>.from(data);

    if (body['startDate'] is DateTime) {
      body['startDate'] = (body['startDate'] as DateTime).toIso8601String();
    }
    if (body['endDate'] is DateTime) {
      body['endDate'] = (body['endDate'] as DateTime).toIso8601String();
    }

    final record = await pb.collection('tasks').update(id, body: body);
    return Task.fromRecord(record);
  }

  /// 할 일을 삭제
  Future<void> deleteTask(String id) async {
    await pb.collection('tasks').delete(id);
  }

  /// 할 일 완료 토글
  Future<Task> toggleDone(Task task) async {
    final updated = await updateTask(task.id!, {
      ...task.toJson(),
      "isDone": !(task.isDone ?? false),
    });

    if (!(task.isDone ?? false)) {
      await AchievementService().updateMetaDataWithKey("complete_task", 1);

      // streak 처리
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final yesterday = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: 1)));
      final user = await userService.getProfile();
      final streak = user.metadata?["taskStreak"] ?? {};
      final lastDate = streak["lastDate"];
      int count = streak["count"] ?? 0;

      if (lastDate == today) {
        // 오늘 이미 처리됨
      } else if (lastDate == yesterday) {
        count += 1;
      } else {
        count = 1;
      }

      user.metadata!["taskStreak"] = {
        "lastDate": today,
        "count": count,
      };

      await AchievementService()
          .updateMetaDataWithKey("complete_task_streak", count);
    }

    return updated;
  }

  /// 루틴 완료 처리 및 보상
  Future<void> handleTaskCompletion(Task task) async {
    final priority = int.tryParse(task.priority ?? "3") ?? 3;
    final exp = priority * 10;

    await userService.grantExperienceToUser(exp);

    await AchievementService().updateMetaDataWithKey("complete_routine", 1);

    // streak 처리
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final yesterday = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));
    final user = await userService.getProfile();
    final streak = user.metadata?["routineStreak"] ?? {};
    final lastDate = streak["lastDate"];
    int count = streak["count"] ?? 0;

    if (lastDate == today) {
      // 오늘 이미 처리됨
    } else if (lastDate == yesterday) {
      count += 1;
    } else {
      count = 1;
    }

    user.metadata!["routineStreak"] = {
      "lastDate": today,
      "count": count,
    };

    await AchievementService()
        .updateMetaDataWithKey("complete_routine_streak", count);

    if (task.isRepeatingTask == true && task.repeatPeriod != null) {
      final repeatDays = int.tryParse(task.repeatPeriod!) ?? 0;

      if (repeatDays > 0) {
        final newTask = task.copyWith(
          id: null,
          startDate: task.startDate?.add(Duration(days: repeatDays)),
          endDate: task.endDate?.add(Duration(days: repeatDays)),
          isDone: false,
          created: null,
          updated: null,
        );
        await createTask(newTask);
      }
    }

    await toggleDone(task);
  }

  Future<List<Task>> _getTasks(String userID) async {
    final now = DateTime.now().toUtc().add(const Duration(hours: 9)); // 한국 시간
    final today = DateTime(now.year, now.month, now.day); // 오늘 날짜만

    final allTasks = await pb.collection("tasks").getFullList(
          filter: "owner.id='$userID'",
        );

    List<Task> todayTasks = [];

    for (final record in allTasks) {
      final task = Task.fromRecord(record);

      if (task.isRepeatingTask == true) {
        // 반복 작업 처리
        final start = task.startDate?.toUtc();
        final period = int.tryParse(task.repeatPeriod ?? "0") ?? 0;

        if (start == null || period <= 0) continue;

        final daysDiff = today
            .difference(
              DateTime(start.year, start.month, start.day),
            )
            .inDays;

        if (daysDiff >= 0 && daysDiff % period == 0) {
          todayTasks.add(task);
        }
      } else {
        // 일반 작업 처리
        final end = task.endDate?.toUtc();
        if (end == null) continue;

        final endDateOnly = DateTime(end.year, end.month, end.day);
        if (endDateOnly == today) {
          todayTasks.add(task);
        }
      }
    }

    return todayTasks;
  }

  Future<int> getTaskGoalCount(String userID) async {
    final tasks = await _getTasks(userID);
    return tasks.length;
  }

  Future<int> getTaskDoneCount(String userID) async {
    final tasks = await _getTasks(userID);
    return tasks.where((task) => task.isDone == true).length;
  }

  Future<bool> todayDone(String userID) async {
    return await getTaskDoneCount(userID) == await getTaskGoalCount(userID);
  }
}
