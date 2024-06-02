import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/widget/color_info.dart';

Widget collectionView(CollectionReference collectionReference) {
  return StreamBuilder(
    stream: collectionReference.snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator(); // 데이터 로딩 중에는 로딩 표시를 반환
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}'); // 에러가 발생하면 에러 메시지를 반환
      } else {
        List<Map<String, dynamic>> dataList = [];
        snapshot.data?.docs.forEach((doc) {
          dataList.add(doc.data() as Map<String, dynamic>);
        });
        if (dataList.isEmpty) {
          return const Center(
            child: Text('nothing to do!'),
          );
        } else {
          return ListView.separated(
            shrinkWrap: true,
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: stateView(dataList[index]['state']),
                title: Text(dataList[index]['name']),
                subtitle: Text(dataList[index]['memo']),
                onTap: () {},
              );
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

Widget stateView(int state) {
  Color color = ColorInfo[state]!;
  return Icon(
    Icons.adjust,
    color: color,
  );
}
