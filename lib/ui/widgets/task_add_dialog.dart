import 'package:flutter/material.dart';
import '../../utils/models/task_model.dart';

Future<TaskModel?> showAddTaskDialog(BuildContext context, List<String> categories) async {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  final categorySet = {'기본', ...categories.where((e) => e != '전체')}.toList();
  String selectedCategory = categorySet.first;

  return showDialog<TaskModel>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('할 일 추가'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: '제목'),
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(labelText: '설명'),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            isExpanded: true,
            value: categorySet.contains(selectedCategory) ? selectedCategory : categorySet.first,
            items: categorySet
                .map((c) => DropdownMenuItem(
              value: c,
              child: Text(c),
            ))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                selectedCategory = val;
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            if (titleController.text.trim().isEmpty) return;

            final newTask = TaskModel(
              id: UniqueKey().toString(),
              title: titleController.text.trim(),
              description: descController.text.trim(),
              category: selectedCategory,
              startDate: DateTime.now(),
              endDate: DateTime.now().add(const Duration(days: 3)),
              tags: ['사용자추가'],
              isImportant: false,
              isCompleted: false,
              priority: 1,
            );

            Navigator.pop(context, newTask);
          },
          child: const Text('추가'),
        ),
      ],
    ),
  );
}
