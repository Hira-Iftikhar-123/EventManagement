import 'package:flutter/material.dart';
import 'package:frontend_project/models/app_bar.dart';
import 'package:frontend_project/api_service.dart';

class AdminEventRequests extends StatefulWidget {
  const AdminEventRequests({super.key});

  @override
  _AdminEventRequestsState createState() => _AdminEventRequestsState();
}

class _AdminEventRequestsState extends State<AdminEventRequests> {
  late Future<List<dynamic>> _eventRequests;

  @override
  void initState() {
    super.initState();
    _eventRequests = ApiService.getAllEventRequests();
  }

  void _handleApprove(int requestId, int index) async {
    try {
      await ApiService.approveEventRequest(requestId);
      setState(() {
        _eventRequests = ApiService.getAllEventRequests();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to approve request: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _handleReject(int requestId, int index) async {
    try {
      await ApiService.rejectEventRequest(requestId);
      setState(() {
        _eventRequests = ApiService.getAllEventRequests();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to reject request: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Event Requests", true, false).buildAppBar(),
      body: FutureBuilder<List<dynamic>>(
        future: _eventRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No event requests found."));
          }

          final eventRequests = snapshot.data!;
          return ListView.builder(
            itemCount: eventRequests.length,
            itemBuilder: (context, index) {
              final request = eventRequests[index];
              bool isApproved = request['status'] == 'approved';
              bool isRejected = request['status'] == 'rejected';

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(request['event_name']),
                  subtitle: Text(
                      "Date: ${request['event_day']}\nStatus: ${request['status']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isApproved && !isRejected)
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => _handleApprove(request['request_id'], index),
                        ),
                      if (!isApproved && !isRejected)
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => _handleReject(request['request_id'], index),
                        ),
                      if (isApproved)
                        Icon(Icons.check_circle, color: Colors.green),
                      if (isRejected)
                        Icon(Icons.cancel, color: Colors.red),
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
