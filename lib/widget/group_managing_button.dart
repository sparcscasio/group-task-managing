// ignore_for_file: void_checks

import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/screen/app_group_page.dart';
import 'package:group_task_manager/screen/new_group_page.dart';
import 'package:group_task_manager/widget/bottom_dialog.dart';

Widget addGroupButton(UserProvider userProvider, BuildContext context) {
  return TextButton(
      onPressed: () {
        return BottomDialog(context, AddGroupPage(userProvider: userProvider));
      },
      child: const Text('add group'));
}

Widget newGroupButton(UserProvider userProvider, BuildContext context) {
  return TextButton(
      onPressed: () {
        return BottomDialog(context, NewGroupPage(userProvider: userProvider));
      },
      child: const Text('new group'));
}
