import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/screen/add_task_page.dart';
import 'package:group_task_manager/widget/bottom_dialog.dart';
import 'package:group_task_manager/widget/collection_view.dart';
import 'package:provider/provider.dart';

class GroupDetailPage extends StatelessWidget {
  int index;
  GroupDetailPage({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    DocumentReference groupref = userProvider.groupReference[index];
    CollectionReference todo = groupref.collection('todo');
    return Scaffold(
      body: collectionView(todo, 'group', context),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          BottomDialog(context, AddTaskPage(groupID: groupref.id));
        },
      ),
    );
  }
}
