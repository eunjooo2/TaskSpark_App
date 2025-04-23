import '../models/task_model.dart';

class TaskService {
  final List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => List.unmodifiable(_tasks);

  void addTask(TaskModel task) {
    _tasks.insert(0, task);
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }
}
