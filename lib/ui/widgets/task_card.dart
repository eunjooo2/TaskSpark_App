import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onDelete;
  final VoidCallback onToggleExpand;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onToggleExpand,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(minHeight: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
              if (task.isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.description, maxLines: 3, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(
                        "기간: ${DateFormat.yMd().format(task.startDate)} ~ ${DateFormat.yMd().format(task.endDate)}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      Wrap(
                        spacing: 6,
                        children: task.tags.map((tag) => Chip(label: Text(tag))).toList(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('삭제 확인'),
                                  content: const Text('정말 삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
                                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
                                  ],
                                ),
                              );
                              if (confirm == true) onDelete();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
