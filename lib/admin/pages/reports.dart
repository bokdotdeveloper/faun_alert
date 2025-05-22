import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.lightGreen,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Notification bell on the right
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                // Add notification logic here
                debugPrint(
                  'Notification bell pressed',
                ); // Use debugPrint for logging
              },
            ),
          ],
        ),
      ),
      body: SafeArea(child: Center(child: const Text('Reports'))),
    );
  }
}
