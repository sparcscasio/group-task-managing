import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    return Center(
        child: TextButton(
            child: Text('set user'),
            onPressed: () {
              userProvider.updateUser();
            }));
  }
}
