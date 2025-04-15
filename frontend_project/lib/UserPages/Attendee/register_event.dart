import 'package:flutter/material.dart';
import 'package:frontend_project/models/app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendeeRegistrationScreen extends StatefulWidget {
  const AttendeeRegistrationScreen({super.key});

  @override
  AttendeeRegistrationScreenState createState() => AttendeeRegistrationScreenState();
}

class AttendeeRegistrationScreenState extends State<AttendeeRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController eventIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedLocation;

  final List<String> paymentLocations =
  [
    'Auditorium',
    'Seminar Room S2',
    'Fast-Nuces, Karachi',
  ];

  Future<void> registerAttendee() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/attendees/register'),
          headers: {"Content-Type": "application/json", "x_api_key": "b289e137-cbfe-4a20-9c71-8285389b62c8",},
          body: jsonEncode({
            'eventId':int.parse(eventIdController.text),
            'name': nameController.text,
            'age': int.parse(ageController.text),
            'education': educationController.text,
            'cnic': cnicController.text,
            'phone': phoneController.text,
            'email': emailController.text,
            'paymentLocation': selectedLocation,
          }),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Registration Successful"),
                content: Text(
                  "You are registered successfully.\nPay at: $selectedLocation.\nYour ID: ${jsonResponse['attendeeId']}",
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else
        {
          throw Exception("Failed to register attendee. ${response.body}");
        }
      } catch (e)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields correctly")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Attendee Register", true, false).buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(eventIdController, "Event Id", TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(nameController, "Name", TextInputType.text),
              const SizedBox(height: 10),
              _buildTextField(ageController, "Age", TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(educationController, "Education", TextInputType.text),
              const SizedBox(height: 10),
              _buildTextField(cnicController, "CNIC", TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(phoneController, "Phone", TextInputType.phone),
              const SizedBox(height: 10),
              _buildTextField(emailController, "Email", TextInputType.emailAddress),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Payment Location',
                  border: OutlineInputBorder(),
                ),
                value: selectedLocation,
                items: paymentLocations.map((location) => DropdownMenuItem(
                  value: location,
                  child: Text(location),
                )).toList(),
                onChanged: (value) => setState(() => selectedLocation = value),
                validator: (value) => value == null ? 'Please select a payment location' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerAttendee,
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType inputType) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "$label is required";
        if (label == "Email" && !RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value)) {
          return "Enter a valid email";
        }
        if (label == "Phone" && value.length != 11) return "Phone must be 11 digits";
        if (label == "CNIC" && value.length != 13) return "CNIC must be 13 digits";
        return null;
      },
    );
  }
}
