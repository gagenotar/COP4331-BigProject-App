import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({Key? key, this.onSuccess, required this.userId}) : super(key: key);

  final Function()? onSuccess; // Define onSuccess callback
  final String userId;

  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  Uint8List? _imageData;
  String? _imageName;

  Future<void> _submitEntry() async {
    if (_imageData == null) {
      _showErrorDialog('Please select an image.');
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://journey-journal-cop4331-71e6a1fdae61.herokuapp.com/api/app/addEntry'),
    );

    request.fields['userId'] = widget.userId;
    request.fields['title'] = _titleController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['location'] = _locationController.text;
    request.fields['rating'] = _ratingController.text;

    var multipartFile = http.MultipartFile.fromBytes(
      'image', // Field name must match the server-side field name
      _imageData!,
      filename: _imageName,
    );

    request.files.add(multipartFile);

    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    print('Response status: ${response.statusCode}');
    print('Response body: ${responseData.body}');

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(responseData.body);
      print('Entry added with ID: ${responseJson['_id']}');
      if (widget.onSuccess != null) {
        widget.onSuccess!(); // Call onSuccess callback if defined
      }
      Navigator.pop(context, true); // Pass true to indicate success
    } else {
      // Handle submission failure
      print('Failed to add entry');
      _showErrorDialog('Error adding entry.');
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        print('Selected image: ${image.name}');
        final Uint8List imageData = await image.readAsBytes();
        setState(() {
          _imageData = imageData;
          _imageName = image.name;
        });
      } else {
        print('No image selected or canceled.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submission Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(),
        child: Padding(
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
                    'Add An Adventure!',
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
                    child: Column(
                      children: <Widget>[
                        _buildTextField(_titleController, 'Title'),
                        SizedBox(height: 10),
                        _buildTextField(_descriptionController, 'Description', maxLines: 3),
                        SizedBox(height: 10),
                        _buildTextField(_locationController, 'Location'),
                        SizedBox(height: 20),
                        _buildTextField(_ratingController, 'Rating'),
                        SizedBox(height: 20),
                        _imageData == null
                            ? Text('No image selected.')
                            : Image.memory(
                          _imageData!,
                          width: 200, // Adjust width if needed
                          height: 200, // Adjust height if needed
                          fit: BoxFit.cover, // Adjust fit if needed
                        ),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Upload Image'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitEntry,
                    child: Text('Add Post'),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {int maxLines = 1,
        TextInputType keyboardType = TextInputType.text}) {
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
