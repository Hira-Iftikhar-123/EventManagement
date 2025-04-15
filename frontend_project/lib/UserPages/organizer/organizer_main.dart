import 'package:flutter/material.dart';
import 'view_requests.dart';
import 'event_request.dart';
import 'package:frontend_project/models/navigation_bar.dart';
import 'attendee_registeration_manager.dart';

class OrganizerMain extends StatefulWidget {
  const OrganizerMain({super.key});

  @override
  OrganizerMainState createState() => OrganizerMainState();
}

class OrganizerMainState extends State<OrganizerMain> {
  @override
  Widget build(BuildContext context) {
    return  CustomNavigationBar(
      destinations: const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.people_sharp, color: Colors.white),
          icon: Icon(Icons.people_outlined, color: Colors.white),
          label: 'Create Event Requests',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.notifications_sharp, color: Colors.white),
          icon: Icon(Icons.notifications_outlined, color: Colors.white),
          label: 'View Requests',
        ),
        NavigationDestination(
            selectedIcon: Icon(Icons.people, color: Colors.white),
            icon: Icon(Icons.people_outline, color: Colors.white),
          label: 'Attendee Registrations',
        ),
      ],
      pages: <Widget>[
        CreateEventRequestScreen(),
        ViewRequestsScreen(),
        OrganizerEventManagement()
      ],
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
    );
  }
}