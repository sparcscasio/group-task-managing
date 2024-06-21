import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/widget/date_picker.dart';
import 'package:group_task_manager/widget/editable_text.dart';
import 'package:group_task_manager/widget/name_stack.dart';
import 'package:provider/provider.dart';

class EditTaskPage extends StatelessWidget {
  late String? groupID;
  late UserProvider userProvider;

  final GlobalKey<EditableTextWidgetState> editableTextKeyName =
      GlobalKey<EditableTextWidgetState>();
  final GlobalKey<EditableTextWidgetState> editableTextKeyMemo =
      GlobalKey<EditableTextWidgetState>();
  final GlobalKey<DatePickerState> datePicker = GlobalKey<DatePickerState>();
  final GlobalKey<NameStackState> workerKey = GlobalKey<NameStackState>();
  final GlobalKey<NameStackState> managerKey = GlobalKey<NameStackState>();

  EditTaskPage({
    super.key,
    this.groupID,
    required this.userProvider,
    this.data,
    required this.type,
  });

  Map<String, Object?>? data;
  String name = '';
  String memo = '';
  DateTime? date;
  List<String> workerList = List.empty();
  String manager = '';
  String type = '';
  var oldManagerData = null;
  var oldWorkerData = null;

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      print(data);
      name = data!['name'].toString();
      memo = data!['memo'].toString();
      if (data!['dudate'] != null) {
        Timestamp? timestamp = data!['duedate'] as Timestamp;
        date = timestamp.toDate();
      }
      List<dynamic> _workerList = data!['worker'] as List<dynamic>;
      workerList = List<String>.from(_workerList);
      manager = data!['manager'] as String;
    }
    final groupReference =
        FirebaseFirestore.instance.collection('group').doc(groupID);
    final todoReference = FirebaseFirestore.instance
        .collection('group')
        .doc(groupID)
        .collection('todo');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        EditableTextWidget(
          defaultText: name,
          onButtonPressed: () {},
          key: editableTextKeyName,
        ),
        EditableTextWidget(
          defaultText: memo,
          onButtonPressed: () {},
          key: editableTextKeyMemo,
        ),
        DatePicker(
          key: datePicker,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Worker',
          style: TextStyle(
              fontSize: 15,
              color: Colors.deepPurple,
              fontWeight: FontWeight.w600),
        ),
        NameStack(
          userProvider: userProvider,
          groupRef: groupReference,
          type: 'worker',
          key: workerKey,
          oldData: workerList,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Manager',
          style: TextStyle(
              fontSize: 15,
              color: Colors.deepPurple,
              fontWeight: FontWeight.w600),
        ),
        NameStack(
          userProvider: userProvider,
          groupRef: groupReference,
          type: 'manager',
          key: managerKey,
          oldData: manager,
        ),
        ElevatedButton(
            onPressed: () {
              editableTextKeyName.currentState?.save();
              editableTextKeyMemo.currentState?.save();
              name =
                  editableTextKeyName.currentState?.currentTextGetter() ?? '';
              memo =
                  editableTextKeyMemo.currentState?.currentTextGetter() ?? '';
              date = datePicker.currentState?.dateGetter();
              workerList = workerKey.currentState?.nameGetter();
              manager = managerKey.currentState?.nameGetter();
              Map<String, Object?> newData = {
                'name': name,
                'memo': memo,
                'duedate': date,
                'worker': workerList,
                'manager': manager,
                'state': 0,
              };
              serverAction(todoReference, newData);
              //Navigator.pop(context);
            },
            child: Text('save'))
      ]),
    );
  }

  serverAction(
      CollectionReference todoReference, Map<String, Object?> newData) {
    if (type == 'add') {
      todoReference.add(newData);
    } else {
      print('new data : ${newData}');
      DocumentReference docRef = data!['reference'] as DocumentReference;
      docRef.set(newData);
    }
  }
}
