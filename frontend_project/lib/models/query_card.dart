import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QueryCard extends StatefulWidget {
  final dynamic event;
  final dynamic query;
  final String userType;
  final String email; // Ensure this is properly declared
  const QueryCard(this.event, this.userType, {super.key, required this.email, this.query});


  @override
  State<QueryCard> createState() => _QueryCardState();
}

class _QueryCardState extends State<QueryCard> {
  final TextEditingController _replyController = TextEditingController();
  String _response = "";
  String title = "";
  String subTitle = "";
  String fieldTitle = "";
  String buttonTitle = "";
  String snackSuccess = "";
  String snackFail = "";
  String snackText = "";

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('Email passed to QueryCard: ${widget.email}');
    } // Print the email here

    if (widget.userType == 'attendee') {
      title = "Send us your query for ${widget.event['event_name']}";
      subTitle = "View all your answered queries in the Dashboard";
      fieldTitle = "Type your question...";
      buttonTitle = "Send";
      snackSuccess = "Query Forwarded!";
      snackFail = "Cannot send empty query!";
    } else if (widget.userType == 'support') {
      title = "Query ${widget.query['query_id']}: ${widget.query['question']} ";
      subTitle = "Submitted by attendee ${widget.query['attendee_id']}";
      fieldTitle = "Type your answer...";
      buttonTitle = "Answer";
      snackSuccess = "Answer Submitted!";
      snackFail = "Cannot answer empty strings";
    }else if (widget.userType == 'promoter') {
      title = "Promote this Event!";
      subTitle = "Add your content below";
      fieldTitle = "......";
      buttonTitle = "Submit";
      snackSuccess = "Promoted";
      snackFail = "Cannot leave field empty";
    }else if (widget.userType == 'feedback') {
      title = "Thank you for attending ${widget.event['event_name']}!";
      subTitle = "Add your feedback below";
      fieldTitle = "......";
      buttonTitle = "Submit";
      snackSuccess = "Feedback Submitted";
      snackFail = "Cannot leave field empty";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Email value in build: ${widget.email}");
    }

    return Dialog(
      backgroundColor: Colors.transparent, // Transparent background for the dialog
      insetPadding: const EdgeInsets.all(16), // Space around the dialog
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.userType == 'attendee'
                ? [const Color(0xFFFFA726), const Color(0xFFFF7043)] // Orange gradient
                : widget.userType == 'support'
                ? [const Color(0xFF4CAF50), const Color(0xFF1E88E5)] // Blue gradient
                : [const Color(0xFF2196F3), const Color(0xFF388E3C)], // Green gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: widget.userType == 'promoter'
                ? Colors.blueGrey.withOpacity(0.3) // Orange gradient
             : Colors.orange.withOpacity(0.6),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subTitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _replyController,
                decoration: InputDecoration(
                  hintText: fieldTitle,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.userType == 'promoter'
                        ? Colors.green
                        : Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _response = _replyController.text;
                    });

                    if (_response.isNotEmpty) {
                      snackText = snackSuccess;
                      if (kDebugMode) {
                        print("Email value: ${widget.email}");
                      }

                      if(widget.userType=='attendee') {
                      submitQuery(widget.event['event_id'], widget.email, _response);
                      }
                      else if (widget.userType=='support'){
                      submitAnswer(widget.query['query_id'], widget.email, _response) ;
                      }
                      else if (widget.userType=='promoter'){
                        promoteEvent(widget.event['event_id'], widget.email, _response ) ;
                      }
                      else if (widget.userType=='feedback'){
                        giveFeedback(widget.event['event_id'], widget.email, _response ) ;
                      }

                      Navigator.pop(context, _response); // Close the dialog
                    } else {
                      snackText = snackFail;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(snackText)),
                    );
                  },
                  child: Text(
                    buttonTitle,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


Future<void> submitQuery(int eventId, String attendeeId, String question) async {


  final url = Uri.parse('http://10.0.2.2:3000/api/query/queries');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'event_id': eventId,
        'attendee_email': attendeeId,// Make sure this is not null
        'question': question,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success response
      if (kDebugMode) {
        print('Query submitted successfully');
      }
    } else {
      // Handle failure response
      if (kDebugMode) {
        print('Failed to submit query: ${response.body}');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error: $e');
    }
  }
}



Future<void> submitAnswer(int queryId, String supportEmail, String answer) async {
  final url = Uri.parse('http://10.0.2.2:3000/api/query/answers'); // Backend endpoint
  try {
    // Make the POST request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'query_id': queryId, // Ensure these parameters match the backend
        'support_email': supportEmail,
        'answer': answer,
      }),
    );

    // Handle the response
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Answer submitted successfully');
      }
    } else {
      if (kDebugMode) {
        print('Failed to submit answer: ${response.body}');
      }
    }
  } catch (e) {
    // Catch and log any errors
    if (kDebugMode) {
      print('Error submitting answer: $e');
    }
  }
}

Future<void> promoteEvent( int eventId, String supportEmail, String marketing) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/marketing'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'marketing': marketing,
        'event_id': eventId, // Ensure this is an integer
        'support_email': supportEmail,
      }),
    );

    if (response.statusCode == 201) {
      if(kDebugMode){
        print("Promotion ADDED!");
      }
    } else {
      throw Exception('Failed to add marketing entry');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Add Error: $e');
    }
  }
}

Future<void> giveFeedback( int eventId, String attendeeEmail, String feedback) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/feedback'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'feedback': feedback,
        'event_id': eventId, // Ensure this is an integer
        'attendee_email': attendeeEmail,
      }),
    );

    if (response.statusCode == 201) {
      if(kDebugMode){
        print("Feedback ADDED!");
      }
    } else {
      throw Exception('Failed to add feedback entry');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Add Error: $e');
    }
  }
}