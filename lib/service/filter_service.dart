import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/service/documnet_service.dart';

Future<bool> ManageFilter(
    DocumentReference documentReference, UserProvider userProvider) async {
  Map<String, dynamic> data = await getDatabyReference(documentReference);
  if (data['manager'] == userProvider.user!.uid) {
    return true;
  }
  return false;
}
