import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend_project/models/query_card.dart';

class QueryList extends StatefulWidget {
  final dynamic events;
  final String email;

  const QueryList({super.key, required this.events, required this.email});

  @override
  State<QueryList> createState() => _QueryListState();
}

class _QueryListState extends State<QueryList> {
  late Future<List<dynamic>> queries;

  @override
  void initState() {
    super.initState();
    // Add debug log to confirm function call
    if (kDebugMode) {
      print('Initializing QueryList for event_id: ${widget.events['event_id']}');
    }
    queries = fetchUnansweredQueries(widget.events['event_id']);
  }

  Future<List<dynamic>> fetchUnansweredQueries(int eventId) async {
    const String url = 'http://10.0.2.2:3000/api/query/unanswered'; // Ensure the route matches your backend

    if (kDebugMode) {
      print('Entering fetchUnansweredQueries with event_id: $eventId');
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'event_id': eventId}),
      );

      if (kDebugMode) {
        print('HTTP POST to $url');
        print('Request Body: ${jsonEncode({'event_id': eventId})}');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Check if the list is empty and log it
        if (data.isEmpty) {
          if (kDebugMode) {
            print('No unanswered queries found (empty list returned).');
          }
        }

        return data; // Return the list, even if empty
      } else {
        if (kDebugMode) {
          print('No unanswered queries or unexpected status code: ${response.statusCode}');
        }
        return []; // Return empty list for any unexpected status
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in fetchUnansweredQueries: $e');
      }
      return []; // Return empty list on error
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
            // Display message in UI when no unanswered queries
            return const Center(
              child: Text(
                'No unanswered queries',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Makes text bold
                  fontSize: 24, // Increases the font size
                ),
              ),
            );
          } else {
            // Handle the case when data is present
            final queryList = snapshot.data!;
            if (kDebugMode) {
              print('Query List: ${queryList.length} items');
            }

            return ListView.builder(
              itemCount: queryList.length,
              itemBuilder: (context, index) {
                final query = queryList[index];
                return QueryCard(widget.events,'support',email: widget.email,query:query);
              },
            );
          }
        },
      ),
    );
  }


}
