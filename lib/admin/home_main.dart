import "package:faun_alert/admin/pages/animals.dart";
import "package:faun_alert/admin/pages/dashboard.dart";
import "package:faun_alert/admin/pages/law.dart";
import "package:faun_alert/admin/pages/profile.dart";
import "package:flutter/material.dart";

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

const _navBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.dashboard_outlined),
    activeIcon: Icon(Icons.dashboard_rounded),
    label: 'Dashboard',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.pets_outlined),
    activeIcon: Icon(Icons.pets_rounded),
    label: 'Animals',
  ),
    BottomNavigationBarItem(
    icon: Icon(Icons.gavel_outlined),
    activeIcon: Icon(Icons.gavel_rounded),
    label: 'Laws',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.supervised_user_circle_outlined),
    activeIcon: Icon(Icons.supervised_user_circle_rounded),
    label: 'Profile',
  ),
];

class _HomeMainState extends State<HomeMain> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Dashboard(), // Placeholder for Home Page
    const Animals(),
    const Law(),
    const Profile(), // Account Page
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo on the left
            Image.asset(
              'assets/AppLogo.png', // Ensure the path is correct
              height: 40, // Adjust height as needed
            ),
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
      bottomNavigationBar:
          isSmallScreen
              ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
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
              const VerticalDivider(thickness: 1, width: 1, color: Colors.lightGreen,),
              // This is the main content.
              Expanded(
                child: Container(
                  color: Colors.lightGreen, // Match the AppBar background color
                  child: _pages[_selectedIndex],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
