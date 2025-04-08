import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/utils/models/task.dart';

import '../widgets/task_card.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Task> _tasks = [];
  final Map<int, bool> _expanded = {};
  bool _loading = false;
  int _loadedPages = 0;
  final int _pageSize = 5;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9 &&
          !_loading) {
        _fetchMore();
      }
    });
  }

  void _loadInitial() {
    _tasks.clear();
    _loadedPages = 0;
    _fetchMore();
  }

  Future<void> _fetchMore() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1)); // TODO: API 호출
    final newTasks = List.generate(
      _pageSize,
          (i) => Task(content: '더미 할 일 ${_loadedPages * _pageSize + i + 1}'),
    );
    setState(() {
      _tasks.addAll(newTasks);
      _loadedPages++;
      _loading = false;
    });
  }

  Future<void> _addTask() async {
    final controller = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.all(3.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('할 일 추가', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 2.h),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(hintText: '무엇을 해야 하나요?'),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        setState(() => _tasks.insert(0, Task(content: controller.text)));
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('추가'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _search() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('카드 검색'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: '검색어 입력'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () {
              final keyword = controller.text.trim();
              Navigator.pop(context);
              if (keyword.isEmpty) return;
              final results = _tasks.where((t) => t.content?.contains(keyword) ?? false).toList();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('검색 결과'),
                  content: results.isEmpty
                      ? const Text('검색 결과가 없습니다.')
                      : SizedBox(
                    width: 80.w,
                    height: 40.h,
                    child: ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (_, i) => ListTile(title: Text(results[i].content ?? '')),
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
      body: _tasks.isEmpty && !_loading
          ? Center(
        child: Text(
          "할 일이 없습니다.\n오른쪽 아래 '+' 버튼을 눌러 추가해보세요!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp),
        ),
      )
          : ListView.builder(
        controller: _scrollController,
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
          return TaskCard(
            task: _tasks[i],
            isExpanded: _expanded[i] ?? false,
            onTap: () => setState(() => _expanded[i] = !(_expanded[i] ?? false)),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _addTask,
            tooltip: '할 일 추가',
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 2.h),
          FloatingActionButton(
            heroTag: 'search',
            onPressed: _search,
            tooltip: '검색',
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
