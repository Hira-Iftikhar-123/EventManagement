import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/app_bar.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<Map<String, dynamic>> feedbackEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchFeedbackEntries(); // Fetch feedback entries on init
  }

  // API endpoint
  final String apiUrl = 'http://10.0.2.2:3000/api/feedback';

  // Show confirmation dialog for deletion
  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Are You Sure to Delete"),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              _deleteFeedbackEntry(id);
              Navigator.of(ctx).pop(); // Close the dialog
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // Show edit feedback entry dialog
  void showFeedbackDialog(String operation, int id, String feedback, int eventId, int attendeeId) {
    final feedbackController = TextEditingController(text: feedback);
    // Remove the TextField for attendee_id and event_id, as these will be pre-filled
    final eventIdController = TextEditingController(text: eventId.toString());
    final attendeeIdController = TextEditingController(text: attendeeId.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("$operation"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(labelText: 'Feedback'),
            ),
            // Show Event ID and Attendee ID as non-editable fields
            Text("Event ID: $eventId", style: const TextStyle(fontSize: 16)),
            Text("Attendee ID: $attendeeId", style: const TextStyle(fontSize: 16)),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              if (operation == 'edit') {
                _updateFeedbackEntry(
                  id,
                  feedbackController.text,
                  int.parse(eventIdController.text),
                  int.parse(attendeeIdController.text),
                );
              }
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text(operation),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchFeedbackEntries() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          feedbackEntries = data.map((item) => {
            "feedback_id": item['feedback_id'],
            "feedback": item['feedback'],
            "event_id": item['event_id'],
            "attendee_id": item['attendee_id'],
          }).toList();
        });
      } else {
        throw Exception('Failed to load feedback entries');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Fetch Error: $e');
      }
    }
  }

  // Update Feedback Entry
  Future<void> _updateFeedbackEntry(int id, String feedback, int eventId, int attendeeId) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'), // Ensure this URL is correct
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "feedback": feedback,
          "event_id": eventId,
          "attendee_id": attendeeId,
        }),
      );

      // Log the response for debugging
      if (kDebugMode) {
        print('Update Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        _fetchFeedbackEntries(); // Refresh the list after successful update
      } else {
        throw Exception('Failed to update feedback entry');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Update Error: $e');
      }
    }
  }

  // Delete Feedback Entry
  Future<void> _deleteFeedbackEntry(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'), // Ensure this URL is correct
      );

      // Log the response for debugging
      if (kDebugMode) {
        print('Delete Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        _fetchFeedbackEntries(); // Refresh the list after successful deletion
      } else {
        throw Exception('Failed to delete feedback entry');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Delete Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Feedback", true, false).buildAppBar(),
      body: ListView.builder(
        itemCount: feedbackEntries.length,
        itemBuilder: (ctx, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              leading: const Icon(Icons.feedback),
              title: Text(feedbackEntries[index]['feedback']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Event ID: ${feedbackEntries[index]['event_id']}'),
                  Text('Attendee ID: ${feedbackEntries[index]['attendee_id']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      final entry = feedbackEntries[index];
                      showFeedbackDialog(
                        'edit',
                        entry['feedback_id'],
                        entry['feedback'],
                        entry['event_id'],
                        entry['attendee_id'],
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(feedbackEntries[index]['feedback_id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
