import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/screen/manage_page.dart';
import 'package:group_task_manager/screen/todo_detail.dart';
import 'package:group_task_manager/widget/bottom_dialog.dart';
import 'package:group_task_manager/widget/color_info.dart';
import 'package:group_task_manager/widget/task_tile.dart';
import 'package:provider/provider.dart';

Widget collectionView(CollectionReference collectionReference, String page,
    BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context, listen: true);
  print(userProvider.user!.uid);
  return StreamBuilder(
    stream: collectionReference.snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator(); // 데이터 로딩 중에는 로딩 표시를 반환
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}'); // 에러가 발생하면 에러 메시지를 반환
      } else {
        List<Map<String, dynamic>> dataList = [];
        if (page == 'group') {
          snapshot.data?.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['reference'] = doc.reference;
            dataList.add(data);
          });
        } else {
          if (page == 'task') {
            snapshot.data?.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['reference'] = doc.reference;
              if (data['worker'].contains(userProvider.user!.uid)) {
                dataList.add(data);
              }
            });
          } else {
            snapshot.data?.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['reference'] = doc.reference;
              if (data['manager'] == userProvider.user!.uid) {
                dataList.add(data);
              }
            });
          }
        }
        if (dataList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('nothing to do!'),
            ),
          );
        } else {
          return ListView.separated(
            shrinkWrap: true,
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              if (page == 'task') {
                return ManageTile(dataList[index], userProvider, context);
              }
              if (page == 'manage') {
                return TaskTile(dataList[index], userProvider, context);
              } else {
                return GroupTile(dataList[index], userProvider, context);
              }
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.grey, // Divider color
                thickness: 1, // Divider thickness
              );
            },
          );
        }
      }
    },
  );
}
