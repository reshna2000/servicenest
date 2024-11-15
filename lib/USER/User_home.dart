import 'package:flutter/material.dart';
import 'package:service_nest/USER/Home.dart';
import 'package:service_nest/USER/Service/viewService.dart';
import 'package:service_nest/USER/Profile.dart';
import 'package:service_nest/colors.dart';

import 'cart.dart';

class UserHome extends StatefulWidget {
  final String userID;

  const UserHome({super.key, required this.userID});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int currentPageIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Home(onSeeAllClicked: _navigateToServices, userID: widget.userID),
      ServiceAdd(),
      UserBookingsPage(),
      Profile(userID: widget.userID),
    ];
  }

  void _navigateToServices() {
    setState(() {
      currentPageIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.c2,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: AppColors.c3,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.design_services_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.design_services, color: Colors.white),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.shopping_cart, color: Colors.white),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.person, color: Colors.white),
            label: 'My Profile',
          ),
        ],
      ),
      body: _pages[currentPageIndex],
    );
  }
}
