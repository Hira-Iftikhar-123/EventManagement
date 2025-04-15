import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:frontend_project/models/app_bar.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  List<Map<String, dynamic>> employees = [];

  @override
  void initState() {
    super.initState();
    _fetchEmployees(); // Fetch employees on init
  }

  // API endpoint
  final String apiUrl = 'http://10.0.2.2:3000/api/employees';

  // Show confirmation dialog for deletion
  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Are You Sure to Delete"),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              _deleteEmployee(id);
              Navigator.of(ctx).pop(); // Close the dialog
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // Show edit employee dialog
  void showEmpDialog(String operation, int id, String fullName, String phone, String email, String hireDate, String role) {
    // Convert phone and hireDate to strings if they are not already
    final fullNameController = TextEditingController(text: fullName);
    final phoneController = TextEditingController(text: phone.toString()); // Ensure phone is a string
    final emailController = TextEditingController(text: email);
    final hireDateController = TextEditingController(text: hireDate.toString()); // Ensure hireDate is a string
    final roleController = TextEditingController(text: role);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("$operation Employee"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: hireDateController,
              decoration: const InputDecoration(labelText: 'Hire Date'),
            ),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              if (operation == 'add') {
                _addEmployee(
                  fullNameController.text,
                  phoneController.text,
                  emailController.text,
                  hireDateController.text,
                  roleController.text,
                );
              } else if (operation == 'edit') {
                _updateEmployee(
                  id, // Use id directly
                  fullNameController.text,
                  phoneController.text,
                  emailController.text,
                  hireDateController.text,
                  roleController.text,
                );
              }
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text(operation),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }


  Future<void> _addEmployee(String fullName, String phone, String email, String hireDate, String role) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "Full_Name": fullName,
          "Phone": phone,
          "Email": email,
          "Hire_Date": hireDate,
          "Role": role,
          "Login_Password": "12345" // Can be customized or taken as input
        }),
      );

      if (kDebugMode) {
        print('Add Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Add Response body: ${response.body}');
      }

      if (response.statusCode == 201) {
        _fetchEmployees(); // Refresh the employee list
      } else {
        throw Exception('Failed to add employee');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Add Error: $e');
      }
    }
  }

  Future<void> _fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          employees = data.map((item) => {
            "Emp_ID": item['Emp_ID'],
            "Full_Name": item['Full_Name'],
            "Phone": item['Phone'],
            "Email": item['Email'],
            "Hire_Date": item['Hire_Date'],
            "Role": item['Role']
          }).toList();
        });
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _updateEmployee(int id, String fullName, String phone, String email, String hireDate, String role) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "Full_Name": fullName,
          "Phone": phone,
          "Email": email,
          "Hire_Date": hireDate,
          "Role": role,
          "Login_Password": "12345" // You may need to handle passwords differently
        }),
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        _fetchEmployees(); // Refresh employee list
      } else {
        throw Exception('Failed to update employee');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Update Error: $e');
      }
    }
  }

  Future<void> _deleteEmployee(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 200) {
        _fetchEmployees(); // Refresh employee list
      } else {
        throw Exception('Failed to delete employee');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Employees",true,false).buildAppBar(),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (ctx, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(employees[index]['Full_Name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone: ${employees[index]['Phone']}'),
                  Text('Email: ${employees[index]['Email']}'),
                  Text('Hire Date: ${DateTime.parse(employees[index]['Hire_Date']).toLocal().toString().split(' ')[0]}'),
                  Text('Role: ${employees[index]['Role']}'),
                ],
              ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        // Extract values from the employee map to pass to the dialog
                        final employee = employees[index];
                        showEmpDialog(
                          'edit',
                          employee['Emp_ID'], // Pass the employee ID
                          employee['Full_Name'],
                          employee['Phone'].toString(),
                          employee['Email'].toString(),
                          employee['Hire_Date'],
                          employee['Role'],
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(employees[index]['Emp_ID']),
                    ),
                  ],
                ),

            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call the dialog for adding a new employee
          showEmpDialog('add', 0, '', '', '', '', '');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
