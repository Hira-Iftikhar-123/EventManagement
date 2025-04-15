import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_project/models/app_bar.dart';
import 'package:frontend_project/api_service.dart';

class CreateEventRequestScreen extends StatelessWidget {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDayController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();

  CreateEventRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Event Request", true, false).buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: eventNameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Event Name",
                labelStyle: TextStyle(color: Colors.white70),
                hintText: "Enter event name ",
                hintStyle: TextStyle(color: Colors.white60),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white60),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Event Day Field
            TextField(
              controller: eventDayController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Event Day",
                labelStyle: TextStyle(color: Colors.white70),
                hintText: "Enter event day ",
                hintStyle: TextStyle(color: Colors.white60),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white60),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Capacity Field
            TextField(
              controller: capacityController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Capacity",
                labelStyle: TextStyle(color: Colors.white70),
                hintText: "Enter event capacity ",
                hintStyle: TextStyle(color: Colors.white60),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white60),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Submit Button
            ElevatedButton(
              onPressed: () async {
                String eventName = eventNameController.text.trim();
                String eventDay = eventDayController.text.trim();
                String capacity = capacityController.text.trim();

                if (eventName.isEmpty || eventDay.isEmpty || capacity.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Event name, day, and capacity are required.")),
                  );
                  return;
                }

                try {
                  String? apiKey = dotenv.env['API_KEY'];
                  if (apiKey == null) {
                    throw Exception("API_KEY is not initialized in dotenv.");
                  }

                  final response = await ApiService.createEventRequest(
                      eventName, eventDay, 3, int.parse(capacity)
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Event Request Created: ${response['message']}")),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to create event request: $e")),
                  );
                }
              },
              child: Text("Submit Request"),
            ),
          ],
        ),
      ),
    );
  }
}
