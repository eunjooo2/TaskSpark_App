import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/utils/models/task.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _sc = ScrollController();
  final _tasks = List.generate(3, (i) => Task(content: 'Just Breathing.'));
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetch();
    _sc.addListener(() {
      if (_sc.position.pixels >= _sc.position.maxScrollExtent * 0.8 && !_loading) {
        _fetch();
      }
    });
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1)); // 실제 API 호출로 대체
    setState(() {
      _loading = false;
    });
  }

  Future<void> _addTask() async {
    final c = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(controller: c, decoration: const InputDecoration(hintText: "Task Content")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (c.text.isNotEmpty) setState(() => _tasks.insert(0, Task(content: c.text)));
              Navigator.pop(context);
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  Future<void> _search() async {
    final c = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('카드 검색'),
        content: TextField(controller: c, decoration: const InputDecoration(hintText: "검색어 입력")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () {
              final kw = c.text.trim();
              Navigator.pop(context);
              if (kw.isEmpty) return;
              final items = _tasks.where((t) => t.content?.contains(kw) ?? false).toList();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('검색 결과'),
                  content: items.isEmpty
                      ? const Text('검색 결과가 없습니다.')
                      : SizedBox(
                    width: 80.w,
                    height: 40.h,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (_, i) => ListTile(title: Text(items[i].content ?? '')),
                    ),
                  ),
                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인'))],
                ),
              );
            },
            child: const Text('검색'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _sc,
        itemCount: _tasks.length + 1,
        itemBuilder: (_, i) {
          if (i == _tasks.length) {
            return _loading
                ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
                : const SizedBox();
          }
          final t = _tasks[i];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Padding(
              padding: EdgeInsets.all(2.h),
              child: Text(t.content ?? '', style: TextStyle(fontSize: 16.sp)),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(heroTag: 'add', onPressed: _addTask, child: const Icon(Icons.add)),
          SizedBox(height: 2.h),
          FloatingActionButton(heroTag: 'search', onPressed: _search, child: const Icon(Icons.search)),
        ],
      ),
    );
  }
}
