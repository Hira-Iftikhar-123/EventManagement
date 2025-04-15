import 'dart:convert';
import 'package:frontend_project/UserPages/Attendee/attendee_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'input_password_dialog.dart';
import 'package:frontend_project/models/app_bar.dart';
import 'button.dart';

class Options extends StatefulWidget {
  const Options({super.key});

  @override
  State<Options> createState() => _Options();
}

class _Options extends State<Options> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(titleText:'Choose',false,true).buildAppBar(),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(0, -0.5),
                child: CustomButton(
                  buttonText: 'Admin',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordDialog(
                          user: 'admin',
                          email: 'admin@gmail.com',
                          onSubmit: (String email,String password) {
                            // Handle password submission
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 0),
                child: CustomButton(
                  buttonText: 'Management',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManagementOptions(),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 0.5),
                child: CustomButton(
                  buttonText: 'Attendee',
                  onPressed: () {
                    _showEmailDialog(context);
                   /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventCategory(),*/
                      //),
                    //);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ManagementOptions extends StatelessWidget{
late final String buttonText;
late final VoidCallback onPressed;
final scaffoldKey = GlobalKey<ScaffoldState>();

ManagementOptions({super.key});


@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 9, 78),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 64,
        title: const Align(
          alignment: AlignmentDirectional(-0.5, 0),
          child: Text(
            'Management',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 35,
              letterSpacing: 0.0,
            ),
          ),
        ),
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            Align(
              alignment: const AlignmentDirectional(0, -0.5),
              child: CustomButton(
                buttonText: 'Organizer',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordDialog(
                        user:'organizer',
                        email: 'organizer?@gmail.com',
                        onSubmit: (String email,String password) {
                          // Handle password submission
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: CustomButton(
                buttonText: 'Coordinator',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordDialog(
                        user:'coordinator',
                        email: 'coordinator?@gmail.com',
                        onSubmit: (String email,String password) {
                          // Handle password submission
                        },
                      ),
                    ),
                  );
                  // Navigate to management screen
                },
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0.5),
              child: CustomButton(
                buttonText: 'Support Specialist',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordDialog(
                        user:'support',
                        email: 'support?@gmail.com',
                        onSubmit: (String email,String password) {
                          // Handle password submission
                        },
                      ),
                    ),
                  );

                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

void _showEmailDialog(BuildContext context) {
  String attendeeEmail = ''; // Variable to store email

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Enter Email'),
        content: TextField(
          decoration: const InputDecoration(hintText: 'Email'),
          onChanged: (value) {
            attendeeEmail = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Close the dialog first
              Navigator.of(dialogContext).pop();

              // Navigate to EventCategory screen immediately
              Navigator.push(
                context, // Use the parent context for navigation
                MaterialPageRoute(
                  builder: (context) => Attendee(email: attendeeEmail),
                ),
              );

              // Optionally, you can still call the backend for logging purposes or other needs
              await handleAttendeeEmail(attendeeEmail);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}


Future<bool> handleAttendeeEmail(String email) async {
  const String apiUrl = 'http://10.0.2.2:3000/api/attendee/activity'; // Replace with your backend URL

  try {
    final response = await http.post(Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      // Successfully checked or added attendee
      if (kDebugMode) {
        print('Backend Response: ${response.body}');
      }
      return true;
    } else {
      // Handle failure cases
      if (kDebugMode) {
        print(' ${response.body}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error connecting to backend: $e');
    }
    return false;
  }
}

