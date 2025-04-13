import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";


class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ElevatedButton(onPressed: () => {
          FirebaseAuth.instance.signOut(),
        }, child: Text('Logout')), // Placeholder for the admin home main content
      ),
    );
  }
}