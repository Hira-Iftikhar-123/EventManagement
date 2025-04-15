/*import 'package:flutter/material.dart';


class EmployeeCRUD extends StatefulWidget {
  @override
  _EmployeeCRUDState createState() => _EmployeeCRUDState();
}

class _EmployeeCRUDState extends State<EmployeeCRUD> {
  // Sample employee data
  List<Map<String, String>> employees = [
    {"name": "Tutor Joes", "contact": "9043017689"},
    {"name": "Stanley", "contact": "9043017689"},
    {"name": "Test", "contact": "1234567890"}
  ];

  // Function to delete employee
  void _deleteEmployee(int index) {
    setState(() {
      employees.removeAt(index);
    });
    Navigator.of(context).pop(); // Close the dialog
  }

  // Show confirmation dialog
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Are You Sure to Delete"),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => _deleteEmployee(index),
            child: Text("Delete"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Close"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee CRUD'),
      ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (ctx, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(employees[index]['name']!),
              subtitle: Text(employees[index]['contact']!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      // Edit functionality here
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new employee functionality here
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
*/