import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/app_bar.dart';
import 'register_event.dart';
import '../../models/query_card.dart';

class EventCategory extends StatefulWidget {
  final String email;
  const EventCategory({super.key, required this.email});

  @override
  State<EventCategory> createState() => _EventCategoryState();
}

class _EventCategoryState extends State<EventCategory> {
  final String baseUrl = 'http://10.0.2.2:3000/api/events';

  Future<List> fetchEventsByCategory(String category, BuildContext context) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$category'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((event) {
          return {
            'event_id': event['event_id'],
            'event_name': event['event_name'],
            'event_date': event['event_date'],
            'event_timings': event['event_timings'] ?? 'N/A',
            'description': event['description'] ?? 'No Description',
            'vendor_name': event['vendor_name'] ?? 'Unknown Vendor',
            'services': event['services'] ?? 'No Services',
            'venue_name': event['venue_name'] ?? 'No Venue Name',
            'venue_address': event['venue_address'] ?? 'No Venue Address',
            'driver_name': event['driver_name'] ?? 'No Driver Name',
            'vehicle_type': event['vehicle_type'] ?? 'No Vehicle Type',
            'pickup_point': event['pickup_point'] ?? 'No Pickup Point',
            'contact_info': event['contact_info'] ?? 'No Contact Info',
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch events for category $category');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching events for category: $category')),
      );
      return [];
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(2, 2, 2, 0.9372549019607843),
      appBar: CustomAppBar(titleText: 'Categories', true, true).buildAppBar(),
      body: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () async {
                      String category = _categories[index];
                      List events = await fetchEventsByCategory(category, context);
                        // Use Navigator.push to show the EventDetailScreen within the same file
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                a_EventDetailScreen(
                                    events: events, email: widget.email),
                          ),
                        );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: index,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2C3E50), // Darker color for depth
                                      Color(0xFF34495E), // Lighter gradient for gloss
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    _images[index],
                                    width: 300,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class a_EventDetailScreen extends StatelessWidget {
   final List events;
  final String email;  // Make email optional
  const a_EventDetailScreen({super.key, required this.events, required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          // Format the date
          final dateString = events[index]['event_date'];
          final formattedDate = dateString != null
              ? DateFormat('MM/dd/yyyy').format(DateTime.parse(dateString))
              : 'No Date';

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
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${events[index]['description'] ?? "No Description"}',
                            softWrap: true,
                            style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 19, color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('Date: $formattedDate', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('Time: ${events[index]['event_timings'] ?? "No Time"}', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.place, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Venue: ${events[index]['venue_name']}', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.map, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text('Address: ${events[index]['venue_address']}', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.store, color: Colors.pink),
                        const SizedBox(width: 8),
                        Text('Vendor: ${events[index]['vendor_name']}', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.fastfood, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text('Menu: ${events[index]['services']}', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.blueGrey),
                        const SizedBox(width: 8),
                        Text('Driver: ${events[index]['driver_name']}', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.directions_bus, color: Colors.greenAccent),
                        const SizedBox(width: 8),
                        Text('Vehicle: ${events[index]['vehicle_type']}', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text('Contact: ${events[index]['contact_info']}', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                    const Divider(),
                    // Event Buttons (Register and Query)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: const Icon(Icons.app_registration, color: Colors.white),
                            label: const Text('Register', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              // Navigation or action for Register button
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AttendeeRegistrationScreen(), // Replace with actual navigation
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
                            label: const Text('Query', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              // Navigation or action for Query button
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  if (kDebugMode) {
                                    print(email);
                                  }
                                  return QueryCard(events[index],'attendee',email:email); // Pass the event name to the ReplyCard
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



// Categories and images list
final List<String> _categories = [
  'Workshops',
  'Competitions',
  'Seminars',
  'Career Fairs',
];

final List<String> _images = [
  'assets/images/Workshops.png',
  'assets/images/Competitions.png',
  'assets/images/Seminars.png',
  'assets/images/CareerFairs.png',
];


