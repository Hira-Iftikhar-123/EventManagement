import 'package:frontend_project/UserPages/Support/support_queries.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend_project/models/query_card.dart';

class EventList extends StatelessWidget {
  final List events;
  final String email;

  const EventList({super.key, required this.events, required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {

          return Card(
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            color: Colors.transparent, // Keep the background transparent for the glossy look
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2C3E50).withOpacity(0.8), // Transparent gloss effect
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
                        Text(
                          '${events[index]['event_name'] ?? "Unnamed Event"}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    const Divider(),
                    // Event Buttons (Register and Query)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Register Button
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: const Icon(Icons.email_outlined, color: Colors.white),
                            label: const Text('Promote', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              // Navigation or action for Register button
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QueryCard(events[index], "promoter", email: email), // Replace with actual navigation
                                ),
                              );
                            },
                          ),
                          // Query Button
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: const Icon(Icons.help_outline, color: Colors.white),
                            label: const Text('View Queries', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              // Navigation or action for Query button
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  if (kDebugMode) {
                                    print(email);
                                  }
                                  return QueryList(email:email, events: events[index]);
                                },
                              );

                            },
                          ),
                        ],
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
