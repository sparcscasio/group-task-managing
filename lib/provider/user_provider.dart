// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/service/documnet_service.dart';

class UserProvider with ChangeNotifier {
  User? user;
  int state = 0;
  String? name;

  List<DocumentReference> groupReference = [];
  List<String> groupName = [];
  Map<String, String> userInfo = {};

  UserProvider({this.user});

  void setUser() {
    updateUser();
    setGroup();
  }

  void getUser() {
    user = FirebaseAuth.instance.currentUser!;
    updateUser();
    notifyListeners();
  }

  Future<bool> checkUser(String? uid) async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('user')
          .doc(user?.uid)
          .get();

      return document.exists;
    } catch (e) {
      print("Error checking document existence: $e");
      return false;
    }
  }

  void updateUser() async {
    bool exist = await checkUser(user?.uid);
    if (!exist) {
      name = user!.email!.split('@')[0];
      Map<String, dynamic> data = {
        'name': name,
        'group': null,
      };
      try {
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection('user').doc(user!.uid);

        await documentReference.set(data);

        print("Document successfully written!");
      } catch (e) {
        print("Error writing document: $e");
      }
    } else {
      Map<String, dynamic> userData = await getDatabyID(user!.uid, 'user');
      name = userData['name'];
    }
    notifyListeners();
  }

  addGroup(String groupID) async {
    try {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('user').doc(user!.uid);
      Map<String, dynamic> userData = await getDatabyReference(userRef);

      DocumentReference groupRef =
          FirebaseFirestore.instance.collection('group').doc(groupID);
      Map<String, dynamic> groupData = await getDatabyReference(groupRef);

      String groupname = groupData['name'];
      Map<String, String> _userInfo =
          Map<String, String>.from(groupData['userinfo']);

      userInfo = {...userInfo, ..._userInfo};

      try {
        userData['group'][groupID] = groupname;
      } catch (error) {
        userData['group'] = {groupID: groupname};
      }

      userRef.set(userData);
      setGroup();

      try {
        groupData['userinfo'][user!.uid] = name;
      } catch (error) {
        groupData['userinfo'] = {user!.uid: name};
      }

      groupRef.set(groupData);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  void setGroup() async {
    Map<String, dynamic> userData = await getDatabyID(user!.uid, 'user');
    groupReference = [];
    groupName = [];
    userData['group'].forEach((key, value) async {
      DocumentReference reference =
          FirebaseFirestore.instance.collection('group').doc(key);
      groupReference.add(reference);
      groupName.add(value);
      Map<String, dynamic> data = await getDatabyReference(reference);
      Map<String, String> _userInfo =
          Map<String, String>.from(data['userinfo']);
      userInfo = {...userInfo, ..._userInfo};
    });
    notifyListeners();
  }

  void changeName(String newname) async {
    name = newname;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('user').doc(user!.uid);
    Map<String, dynamic> userData = await getDatabyReference(userRef);
    userData['name'] = newname;
    userRef.set(userData);

    for (var ref in groupReference) {
      DocumentSnapshot snapshot = await ref.get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      data['userinfo'][user!.uid] = newname;
      ref.set(data);
    }

    notifyListeners();
  }
}
