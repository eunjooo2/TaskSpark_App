import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/utils/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isExpanded;
  final VoidCallback onTap;

  const TaskCard({
    super.key,
    required this.task,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double collapsedHeight = 60;
    const double expandedHeight = 160;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: isExpanded ? expandedHeight : collapsedHeight,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(2.h),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Text(
                task.content ?? '',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Text(
                "자세한 설명 영역입니다.\n(예: 날짜, 태그, 상태 등)",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
