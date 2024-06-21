import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/service/filter_service.dart';
import 'package:group_task_manager/widget/collection_view.dart';
import 'package:provider/provider.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final List<DocumentReference> groupRef = userProvider.groupReference;
    final List<String> groupName = userProvider.groupName;
    print(groupRef);
    return Scaffold(
      body: ListView.builder(
          itemCount: groupRef.length,
          itemBuilder: ((context, index) {
            CollectionReference todoRef = groupRef[index].collection('todo');
            return ExpansionTile(
              title: Text(groupName[index]),
              children: [collectionView(todoRef, 'manage', context)],
            );
          })),
    );
  }
}
