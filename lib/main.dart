import 'package:device_preview/device_preview.dart';
import 'package:faun_alert/pages/Welcome.dart';
import 'package:faun_alert/pages/signin.dart';
import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();

  runApp(
    DevicePreview(builder: (context) =>
      MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Signin(),
    );
  }
}