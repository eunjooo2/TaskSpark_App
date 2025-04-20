import 'package:flutter/material.dart';
import '../../utils/models/task_model.dart';
import '../../utils/services/task_service.dart';
import '../widgets/task_add_dialog.dart';
import '../widgets/task_card.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskService _taskService = TaskService();
  List<String> _categories = ['전체', '개인', '업무', '기본'];
  String _selectedCategory = '전체';
  String _searchKeyword = '';
  int _page = 0;
  final int _pageSize = 20;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String _sortType = '최신순';

  @override
  void initState() {
    super.initState();
    _initializeDemoTasks();
    _scrollController.addListener(_onScroll);
  }

  void _initializeDemoTasks() {
    for (int i = 0; i < 30; i++) {
      _taskService.addTask(TaskModel(
        id: UniqueKey().toString(),
        title: '할 일 ${i + 1}',
        description: '설명 ${i + 1}',
        category: i % 2 == 0 ? '개인' : '업무',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: i % 5)),
        tags: ['중요', '태그${i % 3}'],
        isImportant: i % 2 == 0,
        isCompleted: false,
        priority: i % 3,
      ));
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        _initializeDemoTasks();
        setState(() => _isLoading = false);
      });
    }
  }

  void _sortTasks(List<TaskModel> list) {
    list.sort((a, b) {
      switch (_sortType) {
        case '최신순':
          return b.startDate.compareTo(a.startDate);
        case '제목순':
          return a.title.compareTo(b.title);
        case '우선순위순':
          return b.priority.compareTo(a.priority);
        default:
          return 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _taskService.tasks.where((t) {
      final matchCat = _selectedCategory == '전체' || t.category == _selectedCategory;
      final matchKey = t.title.contains(_searchKeyword);
      return matchCat && matchKey;
    }).toList();

    _sortTasks(filtered);

    final visible = filtered.take((_page + 1) * _pageSize).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("할 일 목록"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final keyword = await _showTextInputDialog("제목 검색", _searchKeyword);
              if (keyword != null) setState(() => _searchKeyword = keyword);
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () async {
              final sort = await _showSortDialog();
              if (sort != null) {
                setState(() {
                  _sortType = sort;
                });
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: visible.length + (_isLoading ? 1 : 0),
              itemBuilder: (_, index) {
                if (index == visible.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final task = visible[index];
                return TaskCard(
                  task: task,
                  onDelete: () {
                    setState(() => _taskService.deleteTask(task.id));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('삭제되었습니다')));
                  },
                  onToggleExpand: () {
                    setState(() => task.isExpanded = !task.isExpanded);
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await showAddTaskDialog(context, _categories);
          if (newTask != null) {
            setState(() => _taskService.addTask(newTask));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: _categories
            .map((cat) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(cat),
            selected: _selectedCategory == cat,
            onSelected: (_) => setState(() => _selectedCategory = cat),
          ),
        ))
            .toList(),
      ),
    );
  }

  Future<String?> _showTextInputDialog(String title, String initValue) async {
    final controller = TextEditingController(text: initValue);
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text("확인")),
        ],
      ),
    );
  }

  Future<String?> _showSortDialog() async {
    return showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("정렬 기준 선택"),
        children: ['최신순', '제목순', '우선순위순']
            .map((e) => SimpleDialogOption(
          onPressed: () => Navigator.pop(context, e),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(e),
              if (_sortType == e) const Icon(Icons.check, color: Colors.blue),
            ],
          ),
        ))
            .toList(),
      ),
    );
  }
}
