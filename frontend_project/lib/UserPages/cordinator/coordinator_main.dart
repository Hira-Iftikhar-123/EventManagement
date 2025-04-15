import 'package:flutter/material.dart';
import 'package:frontend_project/UserPages/cordinator/approved_events.dart';
import 'manage_resources.dart';
import 'package:frontend_project/models/navigation_bar.dart';

class CoordinatorHome extends StatelessWidget {
  const CoordinatorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomNavigationBar(
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.assignment, color: Colors.white),
            icon: Icon(Icons.assignment_turned_in, color: Colors.white),
            label: 'Allocate Resources',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications_sharp, color: Colors.white),
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            label: 'Approved Events',
          )
        ],
        pages: <Widget>[
          CreateEventScreen(),
          ApprovedEventsPage()
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
