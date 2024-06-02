import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/widget/editable_text.dart';
import 'package:provider/provider.dart';

class AddTaskPage extends StatelessWidget {
  late String groupID;
  final GlobalKey<EditableTextWidgetState> editableTextKey_name =
      GlobalKey<EditableTextWidgetState>();

  final GlobalKey<EditableTextWidgetState> editableTextKey_memo =
      GlobalKey<EditableTextWidgetState>();

  AddTaskPage({super.key, required this.groupID});
  String name = '';
  String memo = '';
  @override
  Widget build(BuildContext context) {
    final groupReference =
        FirebaseFirestore.instance.collection('group').doc(groupID);
    final todoReference = groupReference.collection('todo');
    return Column(children: [
      EditableTextWidget(
        defaultText: 'name',
        onButtonPressed: () {},
        key: editableTextKey_name,
      ),
      EditableTextWidget(
        defaultText: 'memo',
        onButtonPressed: () {},
        key: editableTextKey_memo,
      ),
      ElevatedButton(
          onPressed: () {
            name = editableTextKey_name.currentState?.currentTextGetter() ?? '';
            memo = editableTextKey_memo.currentState?.currentTextGetter() ?? '';
            print(name);
            print(memo);
          },
          child: Text('save'))
    ]);
  }
}
