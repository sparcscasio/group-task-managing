// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/widget/editable_text.dart';
import 'package:provider/provider.dart';

class AddGroupPage extends StatelessWidget {
  final GlobalKey<EditableTextWidgetState> editableTextKey =
      GlobalKey<EditableTextWidgetState>();
  late UserProvider userProvider;
  AddGroupPage({super.key, required this.userProvider});

  String groupCode = '';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      EditableTextWidget(
        defaultText: 'group code',
        onButtonPressed: () {
          try {
            String groupID =
                editableTextKey.currentState?.currentTextGetter() ?? '';
            validation(groupID, context, userProvider);
          } catch (error) {
            print('error');
          }
        },
        key: editableTextKey,
      ),
    ]);
  }

  Future<bool> checkGroup(String groupID) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('group')
          .doc(groupID)
          .get();

      return document.exists;
    } catch (e) {
      print("Error checking document existence: $e");
      return false;
    }
  }

  checkAgain(String groupID, UserProvider userProvider) {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('group').doc(groupID);
    return (userProvider.groupReference.contains(ref));
  }

  void validation(
      String groupID, BuildContext context, UserProvider userProvider) async {
    bool exist = await checkGroup(groupID);
    bool again = checkAgain(groupID, userProvider);
    if (!exist) {
      showDialog(
          context: context,
          builder: ((context) {
            return const Dialog(
              child: Text('wrong group code'),
            );
          }));
    } else {
      if (again) {
        showDialog(
            context: context,
            builder: ((context) {
              return const Dialog(
                child: Text('already in group!'),
              );
            }));
      } else {
        userProvider
            .addGroup(editableTextKey.currentState?.currentTextGetter() ?? '');
      }
    }
  }
}
