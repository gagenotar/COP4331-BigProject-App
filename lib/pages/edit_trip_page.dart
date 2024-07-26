import 'dart:convert';
import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import flutter_rating_bar package
import '../components/trip.dart';
import '../components/api_service.dart';
import 'package:image_picker/image_picker.dart'; // For image picking

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
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  double _rating = 0.0;
  String? _imageUrl; // Placeholder for image URL
  File? _imageFile; // To hold the image file

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.trip.title);
    _descriptionController = TextEditingController(text: widget.trip.description);

    if (widget.trip.location is String) {
      final locationParts = (widget.trip.location as String).split(',');
      _streetController = TextEditingController(text: locationParts.length > 0 ? locationParts[0] : '');
      _cityController = TextEditingController(text: locationParts.length > 1 ? locationParts[1] : '');
      _stateController = TextEditingController(text: locationParts.length > 2 ? locationParts[2] : '');
      _countryController = TextEditingController(text: locationParts.length > 3 ? locationParts[3] : '');
    } else if (widget.trip.location is Map) {
      final locationMap = widget.trip.location as Map<String, dynamic>;
      _streetController = TextEditingController(text: locationMap['street'] ?? '');
      _cityController = TextEditingController(text: locationMap['city'] ?? '');
      _stateController = TextEditingController(text: locationMap['state'] ?? '');
      _countryController = TextEditingController(text: locationMap['country'] ?? '');
    }
    _rating = widget.trip.rating?.toDouble() ?? 0.0;
    _imageUrl = widget.trip.imageUrl;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final locationMap = {
          'street': _streetController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'country': _countryController.text,
        };

        // Update trip details using API
        final editedTrip = await ApiService.editEntryByID(
          widget.trip.id,
          title: _titleController.text,
          description: _descriptionController.text,
          location: locationMap, // Pass as a Map directly
          rating: _rating.toInt(),
          imagePath: _imageFile?.path,
        );

        // Navigate back with the updated trip
        Navigator.pop(context, editedTrip);
      } catch (e) {
        print('Error editing trip: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update trip: $e')),
        );
      }
    }
  }


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageUrl = null; // Clear existing image URL when a new image is picked
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Trip')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/logo.png', // Make sure this image path is correct
                  height: 100,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Edit Your Adventure!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildTextField(_titleController, 'Title'),
                        SizedBox(height: 10),
                        _buildTextField(_descriptionController, 'Description', maxLines: 3),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _buildTextField(_streetController, 'Street'),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _buildTextField(_cityController, 'City'),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _buildTextField(_stateController, 'State'),
                              ),
                            ),
                            Expanded(
                              child: _buildTextField(_countryController, 'Country'),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 30.0,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        _imageFile == null && _imageUrl == null
                            ? Text('No image uploaded.')
                            : _imageFile != null
                            ? Image.file(
                          _imageFile!,
                          width: 468, // Adjust width if needed
                          fit: BoxFit.cover, // Adjust fit if needed
                        )
                            : Image.network(
                          _imageUrl!,
                          width: 468, // Adjust width if needed
                          fit: BoxFit.cover, // Adjust fit if needed
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Pick Image'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            textStyle: TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Save Changes'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            textStyle: TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: const Color.fromARGB(255, 1, 6, 16)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}
