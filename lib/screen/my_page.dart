import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/widget/group_managing_button.dart';
import 'package:group_task_manager/widget/editable_text.dart';
import 'package:provider/provider.dart';

class MyPage extends StatelessWidget {
  MyPage({super.key});
  final GlobalKey<EditableTextWidgetState> editableTextKey =
      GlobalKey<EditableTextWidgetState>();
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    User? user = userProvider.user;
    int state = userProvider.state;
    return Center(
        child: Column(
      children: [
        EditableTextWidget(
          key: editableTextKey,
          defaultText: userProvider.name ?? '',
          onButtonPressed: () {
            userProvider.changeName(
                editableTextKey.currentState?.currentTextGetter() ?? '');
          },
        ),
        Text(userProvider.groupName.join(', ')),
        addGroupButton(userProvider, context),
        SignOutButton(),
        newGroupButton(userProvider, context),
      ],
    ));
  }
}
