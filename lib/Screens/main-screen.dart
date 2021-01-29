import 'package:felexo/Color/colors.dart';
import 'package:felexo/Views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).appBarTheme.color,
                // ignore: deprecated_member_use
                title: Text(
                  'Home',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                icon: Icon(
                  Icons.home_outlined,
                  size: 24,
                  color: iconColor,
                )),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).appBarTheme.color,
                // ignore: deprecated_member_use
                title: Text(
                  'Search',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                icon: Icon(
                  Icons.search_outlined,
                  size: 24,
                  color: iconColor,
                )),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).appBarTheme.color,
                // ignore: deprecated_member_use
                title: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                icon: Icon(
                  Icons.category_outlined,
                  size: 24,
                  color: iconColor,
                )),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).appBarTheme.color,
                // ignore: deprecated_member_use
                title: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                icon: Icon(
                  Icons.settings_outlined,
                  size: 24,
                  color: iconColor,
                )),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).appBarTheme.color,
                // ignore: deprecated_member_use
                title: Text(
                  'Profile',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                icon: Icon(
                  Icons.account_circle_outlined,
                  size: 24,
                  color: iconColor,
                )),
          ],
          onTap: (index) {
            HapticFeedback.heavyImpact();
            setState(() {
              _currentIndex = index;
            });
          },
        ));
  }
}
