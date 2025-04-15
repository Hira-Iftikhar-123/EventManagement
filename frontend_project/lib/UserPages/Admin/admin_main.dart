import 'package:frontend_project/UserPages/Admin/admin_event_requests.dart';
import 'package:frontend_project/userPages/Admin/admin_emp.dart';
import 'package:flutter/material.dart';
import 'package:frontend_project/models/navigation_bar.dart';
import 'package:frontend_project/models/logs.dart';
import 'admin_log.dart';

class Admin extends  StatefulWidget
{
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}
class _AdminState extends State<Admin> with WidgetsBindingObserver
{
  final String userEmail = "admin@gmail.com";
  final String userRole = "Admin";

  @override
  void initState()
  {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _logActivity(' logged in');
  }

  @override
  void dispose()
  {
    _logActivity(' logged out');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _logActivity(String activity) async
  {
    Logs logs = Logs();
    await logs.logActivity(userEmail, userRole, activity);
  }

  @override
  Widget build(BuildContext context)
  {
    return  CustomNavigationBar(
      destinations: const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.people_sharp, color: Colors.white),
          icon: Icon(Icons.people_outlined, color: Colors.white),
          label: 'Employees',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.notifications_sharp, color: Colors.white),
          icon: Icon(Icons.notifications_outlined, color: Colors.white),
          label: 'Requests',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.fact_check_sharp, color: Colors.white),
          icon: Icon(Icons.fact_check_outlined, color: Colors.white),
          label: 'Logs',
        ),
      ],
      pages: const <Widget>[
          EmployeeScreen(),
          AdminEventRequests(),
          LogScreen(),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
    );
  }
}

