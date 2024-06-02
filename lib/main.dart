import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/firebase_options.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/screen/auth_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});
 @override
 Widget build(BuildContext context) {
  print('myapp');
   return MaterialApp(
     theme: ThemeData(
       primarySwatch: Colors.blue,
     ),
     home: const AuthGate(),
   );
 }
}
