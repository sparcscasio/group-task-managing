import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

getDueDate(Timestamp? timestamp) {
  if (timestamp != null) {
    DateTime targetDate = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = targetDate.difference(now);
    int daysLeft = difference.inDays;

    if (daysLeft == 0) {
      return const Text(
        'D-day',
        style: TextStyle(
            color: Colors.red, fontSize: 15, fontWeight: FontWeight.w600),
      );
    } else if (daysLeft > 0) {
      return Text(
        'D-$daysLeft',
        style: const TextStyle(fontSize: 15),
      );
    } else {
      daysLeft = -daysLeft;
      return Text('D+$daysLeft',
          style: const TextStyle(color: Colors.red, fontSize: 15));
    }
  } else {
    return const Text(
      'no due',
      style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 202, 201, 201)),
    );
  }
}
