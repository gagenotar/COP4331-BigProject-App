import 'package:flutter/material.dart';
import '../components/trip.dart';
import '../components/api_service.dart';

class EditTripPage extends StatefulWidget {
  final Trip trip;

  const EditTripPage({Key? key, required this.trip}) : super(key: key);

  @override
  _EditTripPageState createState() => _EditTripPageState();
}

class _EditTripPageState extends State<EditTripPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late int _rating;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.trip.title);
    _descriptionController =
        TextEditingController(text: widget.trip.description);
    _locationController = TextEditingController(text: widget.trip.location);
    _rating = widget.trip.rating ?? 0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Edit Trip')),
      body: Form(
        key: _formKey,
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
            SizedBox(height: 16),
            Text('Rating:'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create a Trip object with updated values
        final updatedTrip = Trip(
          id: widget.trip.id,
          userId: widget.trip.userId,
          title: _titleController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          rating: _rating, // Assuming _rating is defined elsewhere
          imageUrl: widget.trip.imageUrl,
        );

        // Call editEntryByID method from ApiService
        final editedTrip = await ApiService.editEntryByID(
          widget.trip.id,
          title: _titleController.text,
          description: _descriptionController.text,
          location: _locationController.text,
          rating: _rating, // Assuming _rating is defined elsewhere
          imagePath: null, // Provide imagePath if needed
        );

        // Navigate back with editedTrip if needed
        Navigator.pop(context, editedTrip);
      } catch (e) {
        print('Error editing trip: $e'); // Debug print
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update trip: $e')),
        );
      }
    }
  }

}
