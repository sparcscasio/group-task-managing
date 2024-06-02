import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ToDoDetialPage extends StatelessWidget {
  late Map<String, dynamic> data;
  late UserProvider userProvider;

  ToDoDetialPage({super.key, required this.data, required this.userProvider});
  @override
  Widget build(BuildContext context) {
    final Map<String, String> userInfo = userProvider.userInfo;
    return Column(
      children: [
        Text('${data['name'] ?? ''}'),
        Text(returnMatchingName(userInfo, data['manager'].toString())),
        workerGetter(userInfo, data['worker'] ?? List.empty()),
      ],
    );
  }

  String returnMatchingName(Map<String, String> userInfo, String key) {
    try {
      return userInfo[key] ?? '';
    } catch (error) {
      return '';
    }
  }

  Text workerGetter(Map<String, String> userInfo, List<dynamic> worker) {
    List<String> workerList = List<String>.from(worker);
    List<String> workername =
        workerList.map((e) => returnMatchingName(userInfo, e)).toList();
    String nameString = workername.join(', ');
    return Text(nameString);
  }
}
