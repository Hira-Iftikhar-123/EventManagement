import 'package:flutter/material.dart';
import 'package:frontend_project/models/app_bar.dart';
import 'package:frontend_project/api_service.dart';

class ViewRequestsScreen extends StatefulWidget {
  const ViewRequestsScreen({super.key});

  @override
  ViewRequestsScreenState createState() => ViewRequestsScreenState();
}

class ViewRequestsScreenState extends State<ViewRequestsScreen> {
  late Future<List<Map<String, dynamic>>> eventRequests;

  @override
  void initState() {
    super.initState();
    eventRequests = ApiService.getAllEventRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Event Requests", true, false).buildAppBar(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: eventRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No event requests found."));
          }

          return ListView(
            children: snapshot.data!.map((request) {
              return Card(
                child: ListTile(
                  title: Text(request['event_name']),
                  subtitle: Text("Status: ${request['status']}"),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
