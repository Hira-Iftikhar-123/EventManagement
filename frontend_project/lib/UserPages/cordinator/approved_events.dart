import 'package:flutter/material.dart';
import 'package:frontend_project/models/app_bar.dart';
import 'package:frontend_project/api_service.dart';

class ApprovedEventsPage extends StatefulWidget {
  const ApprovedEventsPage({super.key});

  @override
  ApprovedEventsPageState createState() => ApprovedEventsPageState();
}

class ApprovedEventsPageState extends State<ApprovedEventsPage> {
  late Future<List<dynamic>> approvedEvents;

  @override
  void initState() {
    super.initState();
    approvedEvents = ApiService.viewApprovedEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Approved Events", true, false).buildAppBar(),
      body: FutureBuilder<List<dynamic>>(
        future: approvedEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No approved events found."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final event = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(event['event_name']),
                  subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                  Text("Date: ${event['event_date']}"),
                  Text("Time: ${event['event_timings']}"),
                  Text("Category: ${event['event_category']}"),
                  ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
