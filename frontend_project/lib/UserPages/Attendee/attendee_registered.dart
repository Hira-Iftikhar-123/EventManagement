import 'dart:convert';
import 'package:frontend_project/models/query_card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisteredEvents extends StatefulWidget
{
  final String email;
  const RegisteredEvents({super.key, required this.email});

  @override
  State<RegisteredEvents> createState() => RegisteredEventsState();
}

class RegisteredEventsState extends State<RegisteredEvents> {
  final String baseUrl = 'http://10.0.2.2:3000/api/events/registered';
  List<Map<String, dynamic>> events = []; // Holds fetched events
  bool isLoading = true; // To show a loading indicator
  String? errorMessage; // For error messages

  @override
  void initState() {
    super.initState();
    fetchRegisteredEvents(widget.email);
  }

  Future<void> fetchRegisteredEvents(String email) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/${Uri.encodeComponent(email)}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          events = data.map<Map<String, dynamic>>((event) {
            return {
              'event_id': event['event_id'],
              'event_name': event['event_name'],
              'event_date': event['event_date'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error: ${response.body}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch events: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Events'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : events.isEmpty
          ? const Center(child: Text('No registered events found.'))
          : ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final dateString = event['event_date'];
          final formattedDate = dateString != null
              ? DateFormat('MM/dd/yyyy').format(DateTime.parse(dateString))
              : 'No Date';
          final eventDate = dateString != null ? DateTime.parse(dateString) : null;
          final isPastEvent = eventDate != null && eventDate.isBefore(DateTime.now());

          return Card(
            key: ValueKey(event['event_name']), // Unique key for each event
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2C3E50).withOpacity(0.8),
                    const Color(0xFF34495E).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.event, color: Colors.purple),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event['event_name'] ?? 'Unnamed Event',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: $formattedDate',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    if (isPastEvent)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const Icon(Icons.feedback, color: Colors.white),
                          label: const Text(
                            'Give Feedback',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            // Navigation or action for feedback button
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QueryCard(event, "feedback", email: widget.email), // Replace with actual navigation
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
