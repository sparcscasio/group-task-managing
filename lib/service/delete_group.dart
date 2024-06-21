import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/service/documnet_service.dart';

DeleteGroup(DocumentReference reference, UserProvider userProvider) async {
  Map<String, dynamic> data = await getDatabyReference(reference);
  print(data);
  Map<String, dynamic> userinfo = data['userinfo'];
  for (var key in userinfo.keys) {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('user').doc(key);
    Map<String, dynamic> userData = await getDatabyReference(userRef);
    Map<String, dynamic> groupData = userData['group'];
    groupData.remove(reference.id);
    userData['group'] = groupData;
    userRef.set(userData);
  }
  await userProvider.setGroup();
  await reference.delete();
}
