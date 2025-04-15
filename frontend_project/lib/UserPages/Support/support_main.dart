import 'package:frontend_project/models/gloss_button.dart';
import 'package:frontend_project/models/query_card.dart';
import 'package:frontend_project/userPages/Attendee/attendee_events.dart';
import 'package:frontend_project/userPages/Support/support_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/navigation_bar.dart';

class Support extends StatefulWidget {
  final String email;
  const Support({super.key, required this.email});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> with WidgetsBindingObserver {
  late Future<List<dynamic>> _events;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _events = fetchEvents();
  }

  Future<List<dynamic>> fetchEvents() async {
    try {
      const url = 'http://10.0.2.2:3000/api/s_events/all'; // Replace with your backend URL
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON response
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw Exception('No events found');
      } else {
        throw Exception('Failed to load events');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching events: $error');
      }
      throw Exception('Error fetching events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomNavigationBar(
      destinations: const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.dashboard_sharp, color: Colors.white),
          icon: Icon(Icons.dashboard_outlined, color: Colors.white),
          label: 'Dashboard',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.question_answer_sharp, color: Colors.white),
          icon: Icon(Icons.question_answer_outlined, color: Colors.white),
          label: 'Queries',
        ),
      ],
      pages: <Widget>[
        GlossyButtonsPage("Manage\n Emails", "   View\nAnswers",'support',widget.email),
        FutureBuilder<List<dynamic>>(
          future: _events,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while waiting for the data
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show an error message if there's an error
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Show a message if no events are found
              return const Center(child: Text('No events available'));
            } else {
              // Pass the resolved data to the EventDetailScreen
              return EventList(events: snapshot.data!, email: widget.email);
            }
          },
        ),
      ],
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
    );
  }
}
