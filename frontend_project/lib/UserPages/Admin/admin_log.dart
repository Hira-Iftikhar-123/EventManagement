import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_project/models/app_bar.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  List logs = [];

  // Fetch logs from API
  Future<void> fetchLogs() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/logs'));
    if (response.statusCode == 200) {
      setState(() {
        logs = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load logs');
    }
  }

  // Delete a log entry
  Future<void> deleteLog(int id) async {
    final response = await http.delete(Uri.parse('http://10.0.2.2:3000/api/logs/$id'));
    if (response.statusCode == 200) {
      // Reload logs after deletion
      fetchLogs();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log deleted successfully')));
    } else {
      throw Exception('Failed to delete log');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLogs(); // Fetch logs when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(titleText:'Logs',true,false).buildAppBar(),
      body: logs.isEmpty
          ? const Center(child: Text(
        'No Logs Found',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 35,
        ),
      ))  // Show a loader until logs are fetched
          : ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
           return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Text('${logs[index]['user_role']}${logs[index]['activity']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${logs[index]['login_time']}'),  // Additional attribute
                  Text('User ID: ${logs[index]['User_ID']}'),  // Another attribute
                  Text('Log ID: ${logs[index]['Log_ID']}'),  // Another attribute
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Are You Sure to Delete'),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            deleteLog(logs[index]['Log_ID']);
                            Navigator.of(ctx).pop();
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
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
