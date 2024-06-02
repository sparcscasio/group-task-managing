import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_task_manager/provider/user_provider.dart';

Future<bool> checkGroup(String groupID) async {
  try {
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('group').doc(groupID).get();

    return document.exists;
  } catch (e) {
    print("Error checking document existence: $e");
    return false;
  }
}

checkAgain(String groupID, UserProvider userProvider) {
  DocumentReference ref =
      FirebaseFirestore.instance.collection('group').doc(groupID);
  return (userProvider.groupReference.contains(ref));
}

newGroup(String name, UserProvider userProvider) async {
  Map<String, Object> data = {};
  data['name'] = name;
  Map<String, String> userinfo = {userProvider.user!.uid: userProvider.name!};
  data['userinfo'] = userinfo;
  CollectionReference ref = FirebaseFirestore.instance.collection('group');
  DocumentReference docRef = await ref.add(data);
  userProvider.addGroup(docRef.id);
}
