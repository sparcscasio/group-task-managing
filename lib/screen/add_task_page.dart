import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/widget/date_picker.dart';
import 'package:group_task_manager/widget/editable_text.dart';
import 'package:group_task_manager/widget/name_stack.dart';
import 'package:provider/provider.dart';

class AddTaskPage extends StatelessWidget {
  late String groupID;
  late UserProvider userProvider;

  final GlobalKey<EditableTextWidgetState> editableTextKeyName =
      GlobalKey<EditableTextWidgetState>();
  final GlobalKey<EditableTextWidgetState> editableTextKeyMemo =
      GlobalKey<EditableTextWidgetState>();
  final GlobalKey<DatePickerState> datePicker = GlobalKey<DatePickerState>();
  final GlobalKey<NameStackState> workerKey = GlobalKey<NameStackState>();
  final GlobalKey<NameStackState> managerKey = GlobalKey<NameStackState>();

  AddTaskPage({super.key, required this.groupID, required this.userProvider});

  String name = '';
  String memo = '';
  DateTime? date;
  List<String> workerList = List.empty();
  String manager = '';

  @override
  Widget build(BuildContext context) {
    final groupReference =
        FirebaseFirestore.instance.collection('group').doc(groupID);
    final todoReference = FirebaseFirestore.instance
        .collection('group')
        .doc(groupID)
        .collection('todo');
    return Column(children: [
      EditableTextWidget(
        defaultText: 'name',
        onButtonPressed: () {},
        key: editableTextKeyName,
      ),
      EditableTextWidget(
        defaultText: 'memo',
        onButtonPressed: () {},
        key: editableTextKeyMemo,
      ),
      DatePicker(
        key: datePicker,
      ),
      NameStack(
        userProvider: userProvider,
        groupRef: groupReference,
        type: 'worker',
        key: workerKey,
      ),
      NameStack(
        userProvider: userProvider,
        groupRef: groupReference,
        type: 'manager',
        key: managerKey,
      ),
      ElevatedButton(
          onPressed: () {
            name = editableTextKeyName.currentState?.currentTextGetter() ?? '';
            memo = editableTextKeyMemo.currentState?.currentTextGetter() ?? '';
            date = datePicker.currentState?.dateGetter();
            workerList = workerKey.currentState?.nameGetter();
            manager = managerKey.currentState?.nameGetter();
            Map<String, Object?> data = {
              'name': name,
              'memo': memo,
              'duedate': date,
              'worker': workerList,
              'manager': manager,
              'state': 0,
            };
            todoReference.add(data);
            //Navigator.pop(context);
          },
          child: Text('save'))
    ]);
  }
}
