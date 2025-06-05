import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../data/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
  });

  String formatDateTime(DateTime? dt) {
    if (dt == null) return '';
    return "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} "
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isFutureTask = task.startDate != null && task.startDate!.isAfter(now);
    final start = formatDateTime(task.startDate);
    final end = formatDateTime(task.endDate);

    final textColor = isFutureTask ? Colors.grey : null;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      child: ListTile(
        leading: Checkbox(
          value: task.isDone ?? false,
          onChanged: isFutureTask ? null : (val) => onChanged(val),
        ),
        title: Text(
          task.title ?? '',
          style: TextStyle(
            fontSize: 17.sp,
            decoration: (task.isDone ?? false) ? TextDecoration.lineThrough : null,
            color: textColor,
          ),
        ),
        subtitle: Text(
          '시작: $start\n종료: $end',
          style: TextStyle(fontSize: 13.sp, color: textColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
