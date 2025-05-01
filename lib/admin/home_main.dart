import "package:faun_alert/admin/pages/dashboard.dart";
import "package:faun_alert/admin/pages/profile.dart";
import "package:faun_alert/admin/pages/reports.dart";
import "package:faun_alert/admin/pages/users.dart";
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
    icon: Icon(Icons.people_alt_outlined),
    activeIcon: Icon(Icons.people_alt_rounded),
    label: 'Users',
  ),
    BottomNavigationBarItem(
    icon: Icon(Icons.report_outlined),
    activeIcon: Icon(Icons.report_rounded),
    label: 'Reports',
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
    const Users(), // Placeholder for Laws Page
    const Reports(),
    const Profile(), // Account Page
  ];

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;

    return Scaffold(
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
              const VerticalDivider(thickness: 1, width: 1),
              // This is the main content.
              Expanded(child: _pages[_selectedIndex]),
            ],
          ),
        ),
      ),
    );
  }
}