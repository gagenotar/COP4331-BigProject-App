import 'package:flutter/material.dart';
import '../components/trip.dart';
import 'package:journey_journal_app/components/api_service_dart';

class AddEntryPage extends StatefulWidget {
  final String? userId;

  const AddEntryPage({Key? key, required this.userId}) : super(key: key);

  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: Text('Add New Trip')),
      body: Form(
        key: _formKey,
     //   color: Colors.yellow[50],
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a title' : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a description' : null,
            ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a location' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Add Trip'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newTrip = await ApiService().addEntry(
          userId: widget.userId,
          title: _titleController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          rating: 0, // Provide a default rating value if needed
          imagePath: null, // Provide null or a valid path to imagePath
        );
        Navigator.pop(context, newTrip);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add trip: $e')),
        );
      }
    }
  }



}