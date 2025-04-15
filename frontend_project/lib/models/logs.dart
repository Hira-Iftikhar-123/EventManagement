import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Logs {
  Future<void> logActivity(String email, String userRole, String activity) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/log-activity');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'email': email,
        'userRole': userRole,
        'activity': activity,
      }),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Activity logged successfully');
      }
    } else {
      if (kDebugMode) {
        print('Failed to log activity: ${response.body}');
      }
    }
  }
}

