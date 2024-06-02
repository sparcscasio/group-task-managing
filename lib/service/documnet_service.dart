import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:group_task_manager/screen/add_task_page.dart';

getParentsID(DocumentReference documentReference, {required AddTaskPage Function(BuildContext context) builder}) async {
  CollectionReference parentCollection = documentReference.parent;
  DocumentReference parentDocRef = parentCollection.parent!;

  return parentDocRef.id;
}
