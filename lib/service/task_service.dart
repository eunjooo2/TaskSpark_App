import 'package:pocketbase/pocketbase.dart';
import '../data/task.dart';
import '../util/secure_storage.dart';
import 'user_service.dart';

class TaskService {
  final PocketBase pb;
  final UserService userService;

  TaskService(this.pb, this.userService);

  /// 로그인한 사용자의 모든 할 일을 조회합니다.
  Future<List<Task>> getAllTasks() async {
    final userId = await SecureStorage().storage.read(key: "userID");

    final result = await pb.collection('tasks').getFullList(
          filter: "owner.id='$userId'",
          sort: "-created",
        );

    return result.map(Task.fromRecord).toList();
  }

  /// 할 일 ID로 단일 할 일을 조회합니다.
  Future<Task?> getTaskById(String id) async {
    try {
      final record = await pb.collection('tasks').getOne(id);
      return Task.fromRecord(record);
    } catch (_) {
      return null;
    }
  }

  /// 새 할 일을 생성합니다.
  Future<Task> createTask(Task task) async {
    final userId = await SecureStorage().storage.read(key: "userID");

    final body = {
      ...task.toJson(),
      "owner": userId,
    };

    final record = await pb.collection('tasks').create(body: body);
    return Task.fromRecord(record);
  }

  /// 할 일을 수정합니다.
  Future<Task> updateTask(String id, Map<String, dynamic> data) async {
    final body = Map<String, dynamic>.from(data);

    // 날짜 포맷 보정
    if (body['startDate'] is DateTime) {
      body['startDate'] = (body['startDate'] as DateTime).toIso8601String();
    }
    if (body['endDate'] is DateTime) {
      body['endDate'] = (body['endDate'] as DateTime).toIso8601String();
    }

    final record = await pb.collection('tasks').update(id, body: body);
    return Task.fromRecord(record);
  }

  /// 할 일을 삭제합니다.
  Future<void> deleteTask(String id) async {
    await pb.collection('tasks').delete(id);
  }

  /// 할 일의 완료 상태를 토글합니다.
  Future<Task> toggleDone(Task task) async {
    final updated = await updateTask(task.id!, {
      ...task.toJson(),
      "isDone": !(task.isDone ?? false),
    });
    return updated;
  }

  /// 완료된 반복 할 일을 처리하고 보상을 지급합니다.
  Future<void> handleTaskCompletion(Task task) async {
    //  경험치 계산: 우선순위 × 10
    final priority = int.tryParse(task.priority ?? "3") ?? 3;
    final exp = priority * 10;

    await userService.grantExperienceToUser(exp);

    // 반복 작업이면 다음 인스턴스 생성
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
    // 할 일 완료 상태
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
