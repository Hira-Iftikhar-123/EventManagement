import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:frontend_project/userPages/organizer/organizer_main.dart';
import 'package:frontend_project/userPages/Admin/admin_main.dart';
import 'package:frontend_project/userPages/Support/support_main.dart';
import 'package:frontend_project/UserPages/Attendee/attendee_main.dart';
import 'package:frontend_project/userPages/cordinator/coordinator_main.dart';
import '../models/app_bar.dart';

Future<void> main() async {
  // Load .env file before app starts
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Dark theme
        scaffoldBackgroundColor: Colors.black, // Black background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const UserRoleSelection(), // Role selection screen
    );
  }
}

class UserRoleSelection extends StatelessWidget {
  const UserRoleSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['API_KEY'] ?? 'No API Key Found';  // Accessing .env values
    final baseUrl = dotenv.env['BASE_URL'] ?? 'No Base URL Found';

    return Scaffold(
      appBar: CustomAppBar(titleText: "Event Management App", false, true).buildAppBar(),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('API Key: $apiKey', style: TextStyle(color: Colors.white)),
            Text('Base URL: $baseUrl', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Admin()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text('Admin'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OrganizerMain()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text('Organizer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CoordinatorHome()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text('Coordinator'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Attendee(email: 'attendee@gmail.com')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text('Attendee'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Support(email: 'support@example.com')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text('Support'),
            ),
          ],
        ),
      ),
    );
  }
}
