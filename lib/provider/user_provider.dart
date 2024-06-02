import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User? user;
  int state = 0;
  String? name;

  List<DocumentReference> groupReference = [];
  List<String> groupName = [];

  UserProvider({this.user});

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
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('user').doc(user!.uid);
      DocumentSnapshot userSnapshot = await userRef.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      name = userData['name'];
    }
    notifyListeners();
  }

  void addGroup(String groupID) async {
    try {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('user').doc(user!.uid);
      DocumentSnapshot userSnapshot = await userRef.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      DocumentReference groupRef =
          FirebaseFirestore.instance.collection('group').doc(groupID);
      DocumentSnapshot groupSnapshot = await groupRef.get();
      Map<String, dynamic> groupData =
          groupSnapshot.data() as Map<String, dynamic>;
      String groupname = groupData['name'];

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
        groupData['user'] = {user!.uid: name};
      }

      groupRef.set(groupData);
      notifyListeners();
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
    }
  }

  void setGroup() async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('user').doc(user!.uid);
    DocumentSnapshot userSnapshot = await userRef.get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    groupReference = [];
    groupName = [];
    userData['group'].forEach((key, value) {
      DocumentReference reference =
          FirebaseFirestore.instance.collection('group').doc(key);
      groupReference.add(reference);
      groupName.add(value);
    });
    notifyListeners();
  }
}