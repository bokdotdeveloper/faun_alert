import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  var items = [
    "Users",
    "Reports",
  ];

  var icons = [
    Icons.person,
    Icons.report,
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(items.length, (index) {
                  return Column(
                    children: [
                      Card(
                        children: [
                          Icon(icons[index], size: 50),
                          SizedBox(height: 10),
                          Text(items[index], style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Recent Reports", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
