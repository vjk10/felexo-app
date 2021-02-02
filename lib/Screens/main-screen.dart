import 'package:felexo/Color/colors.dart';
import 'package:felexo/Views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeView(),
      SearchView(),
      CategoriesView(),
      SettingsView(),
      ProfileView()
    ];
    return Scaffold(
        body: tabs[_currentIndex],
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: FloatingNavbar(
            selectedBackgroundColor: Theme.of(context).colorScheme.secondary,
            borderRadius: 10,
            itemBorderRadius: 10,
            iconSize: 24,
            fontSize: 9,
            padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
            // selectedItemColor: Theme.of(context).colorScheme.primary,
            selectedItemColor: iconColor,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            currentIndex: _currentIndex,
            items: [
              FloatingNavbarItem(
                icon: Icons.dashboard_sharp,
                title: "Curated",
              ),
              FloatingNavbarItem(icon: Icons.search_sharp, title: "Search"),
              FloatingNavbarItem(
                  icon: Icons.category_sharp, title: "Categories"),
              FloatingNavbarItem(icon: Icons.settings_sharp, title: "Settings"),
              FloatingNavbarItem(
                  icon: Icons.account_circle_sharp, title: "Profile"),
            ],
            onTap: (index) {
              HapticFeedback.heavyImpact();
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ));
  }
}
