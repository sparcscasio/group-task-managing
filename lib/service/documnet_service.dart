import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:group_task_manager/screen/add_task_page.dart';

getParentsID(DocumentReference documentReference) async {
  CollectionReference parentCollection = documentReference.parent;
  DocumentReference parentDocRef = parentCollection.parent!;

  return parentDocRef.id;
}

Future<Map<String, dynamic>> getDatabyReference(
    DocumentReference documentReference) async {
  DocumentSnapshot snapshot = await documentReference.get();
  Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

  return data;
}

Future<Map<String, dynamic>> getDatabyID(
    String documentID, String collectionName) async {
  DocumentReference reference =
      FirebaseFirestore.instance.collection(collectionName).doc(documentID);
  Map<String, dynamic> data = await getDatabyReference(reference);
  return data;
}
