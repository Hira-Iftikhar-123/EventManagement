import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend_project/models/app_bar.dart';

class OrganizerEventManagement extends StatefulWidget
{
  const OrganizerEventManagement({super.key});

  @override
  State<OrganizerEventManagement> createState() => _OrganizerEventManagementState();
}

class _OrganizerEventManagementState extends State<OrganizerEventManagement>
{
  List<dynamic> attendees = [];

  Future<void> fetchAttendees() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/attendees/registrations'));
    if (response.statusCode == 200) {
      setState(() {
        attendees = jsonDecode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load attendees. Error: ${response.body}')),
      );
    }
  }

  Future<void> updateRegistrationStatus(int attendeeId, int eventId, String eligibility, String registration) async
  {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/attendees/update_status'),
        headers: {"Content-Type": "application/json", "x_api_key": "b289e137-cbfe-4a20-9c71-8285389b62c8",},
        body: jsonEncode({
          'attendeeId': attendeeId,
          'eventId': eventId,
          'eligibilityStatus': eligibility,
          'registrationStatus': registration,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated successfully!')),
        );
        fetchAttendees();
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void initState()
  {
    super.initState();
    fetchAttendees();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Attendee Registration", true, false).buildAppBar(),
      body: ListView.builder(
        itemCount: attendees.length,
        itemBuilder: (context, index) {
          final attendee = attendees[index];
          return Card(
            child: ListTile(
              title: Text(attendee['name']),
              subtitle: Text("Event: ${attendee['event_id']}, Status: ${attendee['registration_status']}"),
              trailing: DropdownButton<String>(
                value: attendee['registration_status'],
                items: ['Pending', 'Approved', 'Rejected']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    final eligibilityStatus = newStatus == 'Approved' ? 'Eligible' : 'Not Eligible';
                    updateRegistrationStatus(attendee['attendee_id'], attendee['event_id'], eligibilityStatus, newStatus);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
