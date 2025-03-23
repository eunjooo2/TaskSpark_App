import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_spark/ui/widgets/profile.dart';

class TaskSparkDrawer extends StatelessWidget {
  const TaskSparkDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Profile(),
        ],
      ),
    );
  }
}
