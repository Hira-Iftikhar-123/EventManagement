import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend_project/models/app_bar.dart';

class Marketing extends StatefulWidget {
  const Marketing({super.key});

  @override
  State<Marketing> createState() => _MarketingState();
}

class _MarketingState extends State<Marketing> {
  List<Map<String, dynamic>> marketingEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchMarketingEntries(); // Fetch marketing entries on init
  }

  // API endpoint
  final String apiUrl = 'http://10.0.2.2:3000/api/marketing';

  // Show confirmation dialog for deletion
  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Are You Sure to Delete"),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              _deleteMarketingEntry(id);
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

  // Show edit marketing entry dialog
  void showMarketingDialog(String operation, int id, String marketing, int eventId, int supportId) {
    final marketingController = TextEditingController(text: marketing);
    // Remove the TextField for support_id and event_id, as these will be pre-filled
    final eventIdController = TextEditingController(text: eventId.toString());
    final supportIdController = TextEditingController(text: supportId.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("$operation Marketing Entry"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: marketingController,
              decoration: const InputDecoration(labelText: 'Marketing'),
            ),
            // Show Event ID and Support ID as non-editable fields
            Text("Event ID: $eventId", style: const TextStyle(fontSize: 16)),
            Text("Support ID: $supportId", style: const TextStyle(fontSize: 16)),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              if (operation == 'edit') {
                _updateMarketingEntry(
                  id,
                  marketingController.text,
                  int.parse(eventIdController.text),
                  int.parse(supportIdController.text),
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

  Future<void> _fetchMarketingEntries() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          marketingEntries = data.map((item) => {
            "marketing_id": item['marketing_id'],
            "marketing": item['marketing'],
            "event_id": item['event_id'],
            "support_id": item['support_id'],
          }).toList();
        });
      } else {
        throw Exception('Failed to load marketing entries');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Fetch Error: $e');
      }
    }
  }

  // Update Marketing Entry
  Future<void> _updateMarketingEntry(int id, String marketing, int eventId, int supportId) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'), // Ensure this URL is correct
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "marketing": marketing,
          "event_id": eventId,
          "support_id": supportId,
        }),
      );

      // Log the response for debugging
      if (kDebugMode) {
        print('Update Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        _fetchMarketingEntries(); // Refresh the list after successful update
      } else {
        throw Exception('Failed to update marketing entry');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Update Error: $e');
      }
    }
  }

  // Delete Marketing Entry
  Future<void> _deleteMarketingEntry(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'), // Ensure this URL is correct
      );

      // Log the response for debugging
      if (kDebugMode) {
        print('Delete Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        _fetchMarketingEntries(); // Refresh the list after successful deletion
      } else {
        throw Exception('Failed to delete marketing entry');
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
      appBar: CustomAppBar(titleText: "Marketing", true, false).buildAppBar(),
      body: ListView.builder(
        itemCount: marketingEntries.length,
        itemBuilder: (ctx, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              leading: const Icon(Icons.campaign),
              title: Text(marketingEntries[index]['marketing']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Event ID: ${marketingEntries[index]['event_id']}'),
                  Text('Support ID: ${marketingEntries[index]['support_id']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      final entry = marketingEntries[index];
                      showMarketingDialog(
                        'edit',
                        entry['marketing_id'],
                        entry['marketing'],
                        entry['event_id'],
                        entry['support_id'],
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(marketingEntries[index]['marketing_id']),
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
