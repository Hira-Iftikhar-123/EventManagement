import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static Map<String, String> getHeaders() {
    return {
      "Content-Type": "application/json",
      "x_api_key": "b289e137-cbfe-4a20-9c71-8285389b62c8",
    };
  }

  static Future<dynamic> _getRequest(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: getHeaders());
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('GET request failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during GET request: $e');
    }
  }

  static Future<dynamic> _postRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: getHeaders(),
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('POST request failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during POST request: $e');
    }
  }

  static Future<dynamic> _patchRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: getHeaders(),
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('PATCH request failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during PATCH request: $e');
    }
  }

  static Future<void> _deleteRequest(String endpoint) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl$endpoint'), headers: getHeaders());
      if (response.statusCode != 200) {
        throw Exception('DELETE request failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error during DELETE request: $e');
    }
  }
  static Future<Map<String, dynamic>> updateEventRequest(
      int requestId, String eventName, String eventDay, int capacity) async {
    final response = await _patchRequest('/eventRequests/$requestId', {
      "event_name": eventName,
      "event_day": eventDay,
      "capacity": capacity,
    });
    return response;
  }

  static Future<List<Map<String, dynamic>>> getAllEventRequests() async {
    final response = await _getRequest('/eventRequests');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> createEventRequest(
      String eventName, String eventDay, int empId, int capacity) async {
    final response = await _postRequest('/eventRequests/create', {
      "event_name": eventName,
      "event_day": eventDay,
      "emp_id": empId,
      "capacity": capacity,
    });
    return response;
  }

  static Future<void> approveEventRequest(int requestId) async {
    await _patchRequest('/eventRequests/$requestId/approve', {});
  }

  static Future<void> rejectEventRequest(int requestId) async {
    await _patchRequest('/eventRequests/$requestId/reject', {});
  }

  static Future<void> deleteEventRequest(int requestId) async {
    await _deleteRequest('/eventRequests/$requestId');
  }

  static Future<List<Map<String, dynamic>>> viewApprovedEvents() async {
    final response = await _getRequest('/events/approved_events');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> createEvent(Map<String, dynamic> eventData) async {
    final response = await _postRequest('/events/create_event', eventData);
    return response;
  }

  static Future<Map<String, dynamic>> checkResourceAvailability(
      int vendorId, int transportId, int venueId, String eventDate) async {
    final response = await _postRequest('/events/check_resource', {
      "vendor_id": vendorId,
      "transport_id": transportId,
      "venue_id": venueId,
      "event_date": eventDate,
    });
    return response;
  }

    static Future<Map<String, dynamic>> registerAttendee({
      required String name,
      required int age,
      required String education,
      required String cnic,
      required String phone,
      required String email,
      required String paymentLocation,
      required int eventId,
      }) async {
      final url = Uri.parse('$baseUrl/attendees/register');
      final response = await http.post(url,headers: {"Content-Type": "application/json", "x_api_key": "b289e137-cbfe-4a20-9c71-8285389b62c8",},
      body: jsonEncode({
      'name': name,
      'age': age,
      'education': education,
      'cnic': cnic,
      'phone': phone,
      'email': email,
      'paymentLocation': paymentLocation,
      'eventId': eventId,
    }),
    );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      else {
        throw Exception('Failed to register attendee: ${response.body}');
      }
    }
    static Future<List<dynamic>> fetchAttendees() async {
    final response = await http.get(Uri.parse('$baseUrl/attendees/registrations'));
    return jsonDecode(response.body);
    }
    static Future<void> updateRegistrationStatus({
      required int eventId,
      required int attendeeId,
      required String eligibilityStatus,
      required String registrationStatus,
      }) async {
      final url = Uri.parse('$baseUrl/attendees/update_status');
      final response = await http.put(url,headers: {"Content-Type": "application/json", "x_api_key": "b289e137-cbfe-4a20-9c71-8285389b62c8",},
        body: jsonEncode({
          'eventId': eventId,
          'attendeeId': attendeeId,
          'eligibilityStatus': eligibilityStatus,
          'registrationStatus': registrationStatus,
        }),
      );
        if (response.statusCode != 200) {
          throw Exception('Failed to update registration status: ${response.body}');
        }
      }
    }