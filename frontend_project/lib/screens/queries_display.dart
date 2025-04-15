import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QueryAll extends StatefulWidget {
  final String userType;
  final String email;

  const QueryAll({super.key, required this.userType, required this.email});

  @override
  State<QueryAll> createState() => _QueryAllState();
}

class _QueryAllState extends State<QueryAll> {
  late Future<List<dynamic>> queries;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('Initializing QueryList for email: ${widget.email}');
    }

    if (widget.userType == 'attendee') {
      queries = fetchQueriesByAttendee(widget.email);
    } else if (widget.userType == 'support') {
      queries = fetchQueriesBySupport(widget.email);
    }
  }

  Future<List<dynamic>> fetchQueriesByAttendee(String attendeeEmail) async {
    const url = 'http://10.0.2.2:3000/api/query/display_all_a'; // Replace with your server URL
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'attendee_email': attendeeEmail,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('Missing attendee_email');
    } else if (response.statusCode == 404) {
      throw Exception('No queries found for this attendee');
    } else {
      throw Exception('Failed to load queries');
    }
  }

  Future<List<dynamic>> fetchQueriesBySupport(String supportEmail) async {
    const url = 'http://10.0.2.2:3000/api/query/display_all_s'; // Replace with your server URL
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'support_email': supportEmail,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('Missing support_email');
    } else if (response.statusCode == 404) {
      throw Exception('No queries found for this support');
    } else {
      throw Exception('Failed to load queries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: queries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No unanswered queries',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            );
          } else {
            final queryList = snapshot.data!;
            if (kDebugMode) {
              print('Query List: ${queryList.length} items');
            }

            return ListView.builder(
              itemCount: queryList.length,
              itemBuilder: (context, index) {
                final query = queryList[index];

                // Determine the background color based on the query's status
                bool isAnswered = query['status'] == 'answered';

                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isAnswered
                          ? LinearGradient(
                        colors: [Colors.green.shade700, Colors.green.shade900],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : LinearGradient(
                        colors: [Colors.orangeAccent.shade400, Colors.orangeAccent.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ), // If not answered, no gradient, just the default color
                      color: isAnswered ? null : Colors.orange, // Default color when not answered
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userType == 'attendee'
                                ? "'${query['event_name']}'"
                                : "Query ID: ${query['query_id']}\nEvent ID: ${query['event_id']}\nAttendee ID: ${query['attendee_id']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Query: ${query['question']}',
                            style: const TextStyle(
                                fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.userType == 'attendee'
                                ? (query['answer'] == null || query['answer'].isEmpty
                                ? 'Pending'
                                : "Answered by Support ID ${query['support_id']}: ${query['answer']}")
                                : "Answer: ${query['answer']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
