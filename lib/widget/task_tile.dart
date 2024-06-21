import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/screen/todo_detail.dart';
import 'package:group_task_manager/service/date_service.dart';
import 'package:group_task_manager/service/documnet_service.dart';
import 'package:group_task_manager/widget/bottom_dialog.dart';
import 'package:group_task_manager/widget/color_info.dart';

Widget stateView(int state) {
  Color color = ColorInfo[state]!;
  return Icon(
    Icons.adjust,
    color: color,
  );
}

TaskTile(Map<String, dynamic> data, UserProvider userProvider,
    BuildContext context) {
  return ListTile(
    leading: stateView(data['state']),
    title: Text(data['name']),
    subtitle: Text(data['memo']),
    trailing: TaskButton(data, context),
    onTap: () {
      BottomDialog(
        context,
        ToDoDetialPage(
          data: data,
          userProvider: userProvider,
        ),
      );
    },
  );
}

GroupTile(Map<String, dynamic> data, UserProvider userProvider,
    BuildContext context) {
  return ListTile(
    leading: stateView(data['state']),
    title: Text(data['name']),
    subtitle: Text(data['memo']),
    trailing: getDueDate(data['duedate']),
    onTap: () {
      BottomDialog(
        context,
        ToDoDetialPage(
          data: data,
          userProvider: userProvider,
        ),
      );
    },
  );
}

ManageTile(Map<String, dynamic> data, UserProvider userProvider,
    BuildContext context) {
  return ListTile(
    leading: stateView(data['state']),
    title: Text(data['name']),
    trailing: ManagerButton(data, context),
    subtitle: Text(data['memo']),
    onTap: () {
      BottomDialog(
        context,
        ToDoDetialPage(
          data: data,
          userProvider: userProvider,
        ),
      );
    },
  );
}

ManagerButton(Map<String, dynamic> data, BuildContext context) {
  print('data:');
  print(data);
  int state = data['state'];
  DocumentReference reference = data['reference'];
  if (state == 1) {
    return SizedBox(
      width: 100,
      child: Row(
        children: [
          IconButton(
              onPressed: () async {
                await setTodoState(reference, 2);
              },
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              )),
          IconButton(
              onPressed: () async {
                await setTodoState(reference, -1);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ))
        ],
      ),
    );
  } else {
    if (state == -1) {
      return IconButton(
          onPressed: () async {
            await setTodoState(reference, 2);
          },
          icon: const Icon(
            Icons.check,
            color: Colors.green,
          ));
    } else {
      if (state == 0) {
        return const Text(
          '진행중',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        );
      } else {
        return IconButton(
            onPressed: () async {
              await setTodoState(reference, 0);
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.grey,
            ));
      }
    }
  }
}

TaskButton(Map<String, dynamic> data, BuildContext context) {
  int state = data['state'];
  DocumentReference reference = data['reference'];
  if (state == 0 || state == -1) {
    return IconButton(
        onPressed: () async {
          await setTodoState(reference, 1);
        },
        icon: const Icon(
          Icons.file_upload,
          color: Colors.grey,
        ));
  } else {
    if (state == 2) {
      return const Icon(
        Icons.check,
        color: Colors.green,
      );
    }
    return const Text(
      '승인 검토중',
      style: TextStyle(color: Colors.grey, fontSize: 15),
    );
  }
}

setTodoState(DocumentReference reference, int state) async {
  Map<String, dynamic> data = await getDatabyReference(reference);
  data['state'] = state;
  await reference.set(data);
}
