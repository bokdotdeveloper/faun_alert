import 'package:faun_alert/pages/account_page.dart';
import 'package:faun_alert/pages/home_main.dart';
import 'package:faun_alert/pages/law_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    activeIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
   BottomNavigationBarItem(
    icon: Icon(Icons.gavel_outlined),
    activeIcon: Icon(Icons.gavel_rounded),
    label: 'Laws',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline_rounded),
    activeIcon: Icon(Icons.person_rounded),
    label: 'Account',
  ),
];

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final user = FirebaseAuth.instance.currentUser!;

   // List of pages corresponding to each tab
  final List<Widget> _pages = [
    const HomeMain(), // Placeholder for Home Page
    const LawPage(), // Placeholder for Laws Page
    const AccountPage(), // Account Page
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;

    return Scaffold( appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo on the left
          Image.network(
            'https://placehold.co/200x200/000000/FFFFFF/png', // Replace with your logo asset path
            height: 40,
            width: 40,
          ),
          // Notification bell on the right
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Add notification logic here
              print('Notification bell pressed');
            },
          ),
        ],
      ),
    ),
      bottomNavigationBar:
          isSmallScreen
              ? BottomNavigationBar(
                items: _navBarItems,
                currentIndex: _selectedIndex,
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              )
              : null,

      body: SafeArea(
        child: Center(
          child: Row(
            children: <Widget>[
              if (!isSmallScreen)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  extended: isLargeScreen,
                  destinations:
                      _navBarItems
                          .map(
                            (item) => NavigationRailDestination(
                              icon: item.icon,
                              selectedIcon: item.activeIcon,
                              label: Text(item.label!),
                            ),
                          )
                          .toList(),
                ),
              const VerticalDivider(thickness: 1, width: 1),
              // This is the main content.
              Expanded(
                child: _pages[_selectedIndex],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


  // Text('signed in as: ${user.email!}'),
              // MaterialButton(
              //   onPressed: () {
              //     FirebaseAuth.instance.signOut();
              //   },
              //   color: Colors.blue,
              //   textColor: Colors.white,
              //   padding: const EdgeInsets.all(16),
              //   child: const Text('Sign Out'),
              // ),