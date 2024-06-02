import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/widget/collection_view.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final List<DocumentReference> groupRef = userProvider.groupReference;
    final List<String> groupName = userProvider.groupName;
    return Scaffold(
      body: ListView.builder(
          itemCount: groupRef.length,
          itemBuilder: ((context, index) {
            CollectionReference todoRef = groupRef[index].collection('todo');
            return ExpansionTile(
              title: Text(groupName[index]),
              children: [collectionView(todoRef, 'task', context)],
            );
          })),
    );
  }
}
