import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faun_alert/admin/home_main.dart';
import 'package:faun_alert/auth/auth_page.dart';
import 'package:faun_alert/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('User is logged in: ${snapshot.data!.uid}'); // Debugging log
            return FutureBuilder<DocumentSnapshot>(
              future:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(snapshot.data!.uid)
                      .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  final userRole = userSnapshot.data!.get('role') ?? 'user';
                  print('User role: $userRole'); // Debugging log
                  if (userRole == 'admin') {
                    return HomeMain();
                  } else {
                    return HomePage();
                  }
                } else {
                  print('User document does not exist or has no role');
                  return AuthPage();
                }
              },
            );
          } else {
            print('User is not logged in');
            return AuthPage();
          }
        },
      ),
    );
  }
}
