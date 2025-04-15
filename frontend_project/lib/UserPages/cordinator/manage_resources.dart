import 'package:flutter/material.dart';
import 'package:frontend_project/api_service.dart';
import 'package:frontend_project/models/app_bar.dart';

class CreateEventScreen extends StatefulWidget
{
  const CreateEventScreen({super.key});

  @override
  CreateEventScreenState createState() => CreateEventScreenState();
}

class CreateEventScreenState extends State<CreateEventScreen> {
  final TextEditingController requestIdController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController timingsController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController vendorIdController = TextEditingController();
  final TextEditingController transportIdController = TextEditingController();
  final TextEditingController venueIdController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: "Allocate Resources", true, false).buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(requestIdController, "Request ID", TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(descriptionController, "Description:", TextInputType.text),
              const SizedBox(height: 10),
              _buildTextField(budgetController, "Budget", TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(dayController, "Event date (YYYY-MM-DD)", TextInputType.text),
              const SizedBox(height: 10),
              _buildTextField(timingsController, "Event Timings", TextInputType.text),
              const SizedBox(height: 10),
              _buildTextField(categoryController, "Event Category", TextInputType.text),
              const SizedBox(height: 10),
              _buildTextField(vendorIdController, "Vendor ID", TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(transportIdController, "Transport ID", TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(venueIdController, "Venue ID", TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(capacityController, "Requested Capacity", TextInputType.number),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {
                  if (_validateInputs()) {
                    try {
                      final response = await ApiService.createEvent({
                        'request_id': int.parse(requestIdController.text),
                        'description': descriptionController.text,
                        'budget': double.parse(budgetController.text),
                        'event_date': dayController.text,
                        'event_timings': timingsController.text,
                        'category': categoryController.text,
                        'vendor_id': int.parse(vendorIdController.text),
                        'transport_id': int.parse(transportIdController.text),
                        'venue_id': int.parse(venueIdController.text),
                        'requested_capacity': int.parse(capacityController.text),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response['message'])),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  }
                },
                child: const Text("Allocate Resources"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, TextInputType inputType) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  bool _validateInputs() {
    if (requestIdController.text.isEmpty || descriptionController.text.isEmpty || budgetController.text.isEmpty ||
        dayController.text.isEmpty || timingsController.text.isEmpty || categoryController.text.isEmpty || vendorIdController.text.isEmpty
        || transportIdController.text.isEmpty || venueIdController.text.isEmpty || capacityController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields must be filled in")),
      );
      return false;
    }
    return true;
  }
}