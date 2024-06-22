import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/service/delete_group.dart';
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            const Text(
              'user profile',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple),
            ),
            EditableTextWidget(
              key: editableTextKey,
              defaultText: userProvider.name ?? '',
              onButtonPressed: () {
                userProvider.changeName(
                    editableTextKey.currentState?.currentTextGetter() ?? '');
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const SignOutButton(),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 221, 247),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'Groups',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple),
                    ),
                    GroupNameGetter(userProvider),
                    addGroupButton(userProvider, context),
                    newGroupButton(userProvider, context),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

GroupNameGetter(UserProvider userProvider) {
  return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: userProvider.groupName.length,
      itemBuilder: (context, index) {
        String name = userProvider.groupName[index];
        DocumentReference ref = userProvider.groupReference[index];
        return ListTile(
          title: Center(
              child: Text(
            name,
            style: const TextStyle(fontSize: 15, color: Colors.deepPurple),
          )),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await DeleteGroup(ref, userProvider);
            },
          ),
        );
      });
}
