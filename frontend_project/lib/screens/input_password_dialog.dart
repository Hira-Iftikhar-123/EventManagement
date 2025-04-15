import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend_project/userPages/Support/support_main.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';
import 'dart:convert';
import 'package:frontend_project/userPages/Admin/admin_main.dart';

class PasswordDialog extends StatelessWidget {
  final String user;
  final String email;
  final Function(String, String) onSubmit;

  const PasswordDialog({
    required this.email,
    required this.user,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Controllers for the text fields
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController passwordController = TextEditingController();

    return AlertDialog(
      title: const Text('Login'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Email input field
          TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: "Enter your email"),
          ),
          const SizedBox(height: 10),
          // Password input field
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(hintText: "Enter your password"),
            obscureText: true, // Mask the password input
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () async {
            String inputEmail = emailController.text;
            String inputPassword = passwordController.text;
            if (kDebugMode) {
              print('Input Email: $inputEmail');
              print('Input Password: $inputPassword');
            }

            try {
              final response = await http.post(
                Uri.parse('http://10.0.2.2:3000/api/verify-password'),
                headers: {'Content-Type': 'application/json'},
                body: json.encode({'email': inputEmail, 'password': inputPassword}),
              );

              if (kDebugMode) {
                print('Response Status: ${response.statusCode}');
                print('Response Body: ${response.body}');
              }

              if (response.statusCode == 200)
              {
                onSubmit(inputEmail, inputPassword);
                json.decode(response.body);


                if (user == 'admin') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Admin()),
                  );
                } else if (user == 'support') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Support(email: inputEmail)),
                  );
                }
              } else if (response.statusCode == 401) {
                // Invalid password
                if (await Vibration.hasVibrator() == true) {
                  Vibration.vibrate(duration: 1000);
                }
              } else {
                if (kDebugMode) {
                  print('Error: ${response.body}');
                }
              }
            } catch (e) {
              if (kDebugMode) {
                print('Error occurred: $e');
              }
            }
          },

        ),
      ],
    );
  }
}
