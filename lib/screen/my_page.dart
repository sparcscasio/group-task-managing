import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:provider/provider.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    User? user = userProvider.user;
    int state = userProvider.state;
    return Center(
        child: Column(
      children: [
        Text('${userProvider.name}}'),
        TextButton(
            onPressed: () {
              userProvider.addGroup('NNiZiDgU2ve3lH5jBO0c');
            },
            child: Text('add group')),
        SignOutButton(),
      ],
    ));
  }
}
