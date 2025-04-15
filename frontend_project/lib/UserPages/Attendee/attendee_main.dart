import 'package:frontend_project/models/gloss_button.dart';
import 'package:frontend_project/userPages/Attendee/attendee_events.dart';
import 'package:flutter/material.dart';
import 'register_event.dart';
import 'approved_events.dart';
import '../../models/navigation_bar.dart';

class Attendee extends  StatefulWidget
{
  final String email;
  const Attendee({super.key, required this.email});

  @override
  State<Attendee> createState() => _AttendeeState();
}

class _AttendeeState extends State<Attendee> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

@override
Widget build(BuildContext context) {
  return  CustomNavigationBar(
    destinations: const <NavigationDestination>[
      NavigationDestination(
        selectedIcon: Icon(Icons.dashboard_sharp, color: Colors.white),
        icon: Icon(Icons.dashboard_outlined, color: Colors.white),
        label: 'Attendee',
      ),
      NavigationDestination(
        selectedIcon: Icon(Icons.event_sharp, color: Colors.white),
        icon: Icon(Icons.event_outlined, color: Colors.white),
        label: 'Events',
      ),
      NavigationDestination(
        selectedIcon: Icon(Icons.notifications_sharp, color: Colors.white),
        icon: Icon(Icons.notifications_outlined, color: Colors.white),
        label: 'Approve Events',
      ),
      NavigationDestination(
        selectedIcon: Icon(Icons.add_circle_sharp, color: Colors.white),
        icon: Icon(Icons.add_circle_outline, color: Colors.white),
        label: 'Register',
      ),
    ],
    pages: <Widget>[
      GlossyButtonsPage("View\nFeedback","View \n Queries",'attendee',widget.email),
      EventCategory(email: widget.email),
      ApprovedEventsPage(),
      AttendeeRegistrationScreen()
    ],
    selectedItemColor: Colors.blueAccent,
    unselectedItemColor: Colors.grey,
  );
}
}




